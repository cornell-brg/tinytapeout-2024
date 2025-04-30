
module Ps2DataCollection
(
  input  logic       clk,
  input  logic       rst,

  input  logic       ps2_clk,
  input  logic       ps2_data,

  output logic [7:0] received_data,
  output logic       valid
);

  //FSM STATES
  localparam WAIT_BREAK_CODE     = 3'h0;
  localparam CHECK_START_BIT     = 3'h1;
  localparam RECIEVE_DATA        = 3'h2;
  localparam CHECK_DATA_PARITY   = 3'h3;
  localparam CHECK_DATA_STOP     = 3'h4;

  //INTERNAL WIRES
  logic [3:0] data_count;
  logic [7:0] data_shift_reg;
  logic [2:0] reg_ps2_clk;
  logic pos_edge_ps2_clk;
  logic       break_code_found;

  //FSM internal states
(* keep = 1 *)logic [2:0] current_state;
(* keep = 1 *)logic [2:0] next_state;

  //FSM
  always_ff @(posedge clk)
  begin
if (rst)
current_state <= WAIT_BREAK_CODE;
else
current_state <= next_state;
  end

  always_comb
  begin
case (current_state)
WAIT_BREAK_CODE:
   begin
if (data_shift_reg == 8'hF0)
next_state = CHECK_START_BIT; //use wait intstead of start
else
next_state = WAIT_BREAK_CODE;
end
CHECK_START_BIT:
begin
if ((pos_edge_ps2_clk) && (~ps2_data))
next_state = RECIEVE_DATA;
else
next_state = CHECK_START_BIT;
end
RECIEVE_DATA:
begin
if ((data_count == 4'h8) && (pos_edge_ps2_clk))
next_state = CHECK_DATA_PARITY;
else
 next_state = RECIEVE_DATA;
end
CHECK_DATA_PARITY:
 begin
if (pos_edge_ps2_clk) //odd partity
next_state = CHECK_DATA_STOP;
else if (pos_edge_ps2_clk)
next_state = WAIT_BREAK_CODE;
else
next_state = CHECK_DATA_PARITY;
end
  CHECK_DATA_STOP:
 begin
if ((pos_edge_ps2_clk) && ps2_data)
next_state = WAIT_BREAK_CODE;
else
next_state = CHECK_DATA_STOP;
end
default:
begin
next_state = WAIT_BREAK_CODE;
end
endcase

end

/*****************************************************************************
 *                             Sequential logic                              *
 *****************************************************************************/

//synchronizing ps2 clk
always_ff @(posedge clk)
begin
reg_ps2_clk <= {reg_ps2_clk[1:0], ps2_clk};
end

//data count
always_ff @(posedge clk)
begin
if (rst == 1'b1)
data_count <= 4'h0;
else if ((current_state == RECIEVE_DATA) && pos_edge_ps2_clk)
data_count <= data_count + 4'h1;
else if (current_state != RECIEVE_DATA)
data_count <= 4'h0;
end


always_ff @(posedge clk) begin
    if (rst) begin
        data_shift_reg <= 8'h00;
    end else begin
        if (pos_edge_ps2_clk) begin
            case (current_state)
                WAIT_BREAK_CODE: begin
                    data_shift_reg <= {ps2_data, data_shift_reg[7:1]};
                end
                RECIEVE_DATA: begin
                    if (data_count <4'h8)
                        data_shift_reg <= {ps2_data, data_shift_reg[7:1]};
                end
                // Other states can keep the data_shift_reg unchanged
                default: begin
                    data_shift_reg <= data_shift_reg;
                end
            endcase
        end
    end
end

//setting the valid bit on posedge of clk


logic seen_stop_one;  // Track if we've seen a 1 in stop state

always_ff @(posedge clk) begin
    if (rst == 1'b1) begin
        valid <= 1'b0;
        seen_stop_one <= 1'b0;
    end
    else begin
        // Reset seen_stop_one when leaving stop state
        if (current_state != CHECK_DATA_STOP)
            seen_stop_one <= 1'b0;
				valid <= 1'b0;
           
        // Assert valid only on first cycle we see ps2_data become 1
        if (current_state == CHECK_DATA_STOP && ps2_data == 1'b1 && !valid && !seen_stop_one) begin
            valid <= 1'b1;
            seen_stop_one <= 1'b1;  // Remember we've seen a 1
        end
        else
            valid <= 1'b0;
    end
end


/*****************************************************************************
 *                            Combinational logic                            *
 *****************************************************************************/
 
 assign pos_edge_ps2_clk = (reg_ps2_clk[2:1]==2'b01); //positive edge collection
 assign received_data = data_shift_reg;
//assign valid = current_state == CHECK_DATA_STOP && ps2_data == 1'b1 && !seen_stop_one;

endmodule
