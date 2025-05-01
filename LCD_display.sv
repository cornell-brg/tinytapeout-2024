module LCD_display (
  input  logic       clk,
  input  logic       rst,
  input  logic       ascii_value_valid,
  input  logic [7:0] ascii_value,
  output logic [7:0] lcd_display_code,
  output logic       reg_sel,
  output logic       read_write,
  output logic       enable,
  output logic       got_to_left1,
  output logic       got_to_left2
);

// Local signals
logic [7:0] next_lcd_display_code;
logic [3:0] current_state;  
logic [3:0] next_state;
logic [7:0] current_cursor;


// At 50 MHz, 1 cycle = 20ns
localparam VDD_DELAY_CYCLES            = 800000;  // >15ms after VDD > 4.5V (15ms = 750,000 cycles)
localparam FUNCTION_SET1_DELAY_CYCLES  = 210000;  // >4.1ms (4.1ms = 205,000 cycles)
localparam FUNCTION_SET2_DELAY_CYCLES  = 210000;  // >100us (100us = 5,000 cycles)
localparam DISPLAY_OFF_DELAY_CYCLES    = 210000;  // >53us (53us = 2,650 cycles)
localparam CLEAR_DISPLAY_DELAY_CYCLES  = 800000;  // >4.1ms (4.1ms = 205,000 cycles)
localparam ENTRY_MODE_DELAY_CYCLES     = 210000;  // >53us (53us = 2,650 cycles)
localparam DISPLAY_ON_DELAY_CYCLES     = 210000;  // >53us (53us = 2,650 cycles)

// Enable signal timing
localparam ENABLE_DELAY_CYCLES = 50;         // 500ns (25 cycles at 20ns per cycle)
localparam ENABLE_HIGH_CYCLES  = 80;          // 800ns (minimum enable high time)


logic [19:0] delay_counter; // 20 bits can count up to ~1M cycles


localparam WAIT_VDD        = 4'd0;
localparam FUNCTION_SET1   = 4'd1; 
localparam FUNCTION_SET2   = 4'd2; 
localparam FUNCTION_SET3   = 4'd3;
localparam DISPLAY_OFF     = 4'd4;
localparam CLEAR_DISPLAY   = 4'd5;
localparam ENTRY_MODE      = 4'd6;
localparam DISPLAY_ON      = 4'd7;
localparam RECEIVE_DATA    = 4'd8;
localparam CURSOR_LEFT1    = 4'd9;
localparam REPLACE_DATA    = 4'd10;
localparam CURSOR_LEFT2    = 4'd11;
localparam ENTER           = 4'd12;




// --------------------------------------------------------------------
// LCD Display Codes
// --------------------------------------------------------------------
localparam a_lcd        = 8'h41;
localparam b_lcd        = 8'h42;
localparam c_lcd        = 8'h43;
localparam d_lcd        = 8'h44;
localparam e_lcd        = 8'h45;
localparam f_lcd        = 8'h46;
localparam g_lcd        = 8'h47;
localparam h_lcd        = 8'h48;
localparam i_lcd        = 8'h49;
localparam j_lcd        = 8'h4A;
localparam k_lcd        = 8'h4B;
localparam l_lcd        = 8'h4C;
localparam m_lcd        = 8'h4D;
localparam n_lcd        = 8'h4E;
localparam o_lcd        = 8'h4F;
localparam p_lcd        = 8'h50;
localparam q_lcd        = 8'h51;
localparam r_lcd        = 8'h52;
localparam s_lcd        = 8'h53;
localparam t_lcd        = 8'h54;
localparam u_lcd        = 8'h55;
localparam v_lcd        = 8'h56;
localparam w_lcd        = 8'h57;
localparam x_lcd        = 8'h58;
localparam y_lcd        = 8'h59;
localparam z_lcd        = 8'h5A;
localparam clear_lcd    = 8'h01;

localparam zero_lcd     = 8'h30;
localparam one_lcd      = 8'h31;
localparam two_lcd      = 8'h32;
localparam three_lcd    = 8'h33;
localparam four_lcd     = 8'h34;
localparam five_lcd     = 8'h35;
localparam six_lcd      = 8'h36;
localparam seven_lcd    = 8'h37;
localparam eight_lcd    = 8'h38;
localparam nine_lcd     = 8'h39;
localparam space_lcd     = 8'h20;
localparam backspace_lcd  = 8'd8;
localparam cursor_left_lcd  = 8'h10;


//ascii in all caps:
localparam  ascii_a	 = 8'd65;
localparam  ascii_b	 = 8'd66;
localparam  ascii_c	 = 8'd67;
localparam  ascii_d	 = 8'd68;
localparam  ascii_e	 = 8'd69;
localparam  ascii_f	 = 8'd70;
localparam  ascii_g	 = 8'd71;
localparam  ascii_h	 = 8'd72;
localparam  ascii_i	 = 8'd73;
localparam  ascii_j	 = 8'd74;
localparam  ascii_k	 = 8'd75;
localparam  ascii_l	 = 8'd76;
localparam  ascii_m	 = 8'd77;
localparam  ascii_n	 = 8'd78;
localparam  ascii_o	 = 8'd79;
localparam  ascii_p	 = 8'd80;
localparam  ascii_q	 = 8'd81;
localparam  ascii_r	 = 8'd82;
localparam  ascii_s	 = 8'd83;
localparam  ascii_t	 = 8'd84;
localparam  ascii_u	 = 8'd85;
localparam  ascii_v	 = 8'd86;
localparam  ascii_w	 = 8'd87;
localparam  ascii_x	 = 8'd88;
localparam  ascii_y   = 8'd89;
localparam  ascii_z	 = 8'd90;
localparam  ascii_0	 = 8'd48;
localparam  ascii_1	 = 8'd49;
localparam  ascii_2	 = 8'd50;
localparam  ascii_3	 = 8'd51;
localparam  ascii_4	 = 8'd52;
localparam  ascii_5	 = 8'd53;
localparam  ascii_6	 = 8'd54;
localparam  ascii_7	 = 8'd55;
localparam  ascii_8	 = 8'd56;
localparam  ascii_9	 = 8'd57;
localparam  ascii_space	 = 8'd32;
localparam  ascii_backspace = 8'd8;
localparam ascii_enter = 8'd13;


// ASCII TO LCD MAPPING
always_comb begin
  case (ascii_value)
    ascii_a:  next_lcd_display_code = a_lcd;
    ascii_b:  next_lcd_display_code = b_lcd;
    ascii_c:  next_lcd_display_code = c_lcd;
    ascii_d:  next_lcd_display_code = d_lcd;
    ascii_e:  next_lcd_display_code = e_lcd;
    ascii_f:  next_lcd_display_code = f_lcd;
    ascii_g:  next_lcd_display_code = g_lcd;
    ascii_h:  next_lcd_display_code = h_lcd;
    ascii_i:  next_lcd_display_code = i_lcd;
    ascii_j:  next_lcd_display_code = j_lcd;
    ascii_k:  next_lcd_display_code = k_lcd;
    ascii_l:  next_lcd_display_code = l_lcd;
    ascii_m:  next_lcd_display_code = m_lcd;
    ascii_n:  next_lcd_display_code = n_lcd;
    ascii_o:  next_lcd_display_code = o_lcd;
    ascii_p:  next_lcd_display_code = p_lcd;
    ascii_q:  next_lcd_display_code = q_lcd;
    ascii_r:  next_lcd_display_code = r_lcd;
    ascii_s:  next_lcd_display_code = s_lcd;
    ascii_t:  next_lcd_display_code = t_lcd;
    ascii_u:  next_lcd_display_code = u_lcd;
    ascii_v:  next_lcd_display_code = v_lcd;
    ascii_w:  next_lcd_display_code = w_lcd;
    ascii_x:  next_lcd_display_code = x_lcd;
    ascii_y:  next_lcd_display_code = y_lcd;
    ascii_z:  next_lcd_display_code = z_lcd;
    ascii_0:  next_lcd_display_code = zero_lcd;
    ascii_1:  next_lcd_display_code = one_lcd;
    ascii_2:  next_lcd_display_code = two_lcd;
    ascii_3:  next_lcd_display_code = three_lcd;
    ascii_4:  next_lcd_display_code = four_lcd;
    ascii_5:  next_lcd_display_code = five_lcd;
    ascii_6:  next_lcd_display_code = six_lcd;
    ascii_7:  next_lcd_display_code = seven_lcd;
    ascii_8:  next_lcd_display_code = eight_lcd;
    ascii_9:  next_lcd_display_code = nine_lcd;
	 ascii_space:  next_lcd_display_code = space_lcd;
	 ascii_backspace: next_lcd_display_code = space_lcd;
    default: next_lcd_display_code  = zero_lcd;
  endcase
end


always_comb begin
  case (current_state)
    WAIT_VDD:
      if (delay_counter >= VDD_DELAY_CYCLES) // Wait >15ms after VDD > 4.5V
        next_state = FUNCTION_SET1;
      else
        next_state = WAIT_VDD;

    FUNCTION_SET1:    
      if (delay_counter >= FUNCTION_SET1_DELAY_CYCLES) // Wait >4.1ms
        next_state = FUNCTION_SET2;
      else
        next_state = FUNCTION_SET1;
       
    FUNCTION_SET2:    
      if (delay_counter >= FUNCTION_SET2_DELAY_CYCLES) // Wait >100us
        next_state = FUNCTION_SET3;
      else
        next_state = FUNCTION_SET2;
       
    FUNCTION_SET3:    
      if (delay_counter >= FUNCTION_SET2_DELAY_CYCLES) // Wait >100us
        next_state = DISPLAY_OFF;
      else
        next_state = FUNCTION_SET3;
       
    DISPLAY_OFF:    
      if (delay_counter >= DISPLAY_OFF_DELAY_CYCLES) // Wait >53us
        next_state = CLEAR_DISPLAY;
      else
        next_state = DISPLAY_OFF;
       
    CLEAR_DISPLAY:
      if (delay_counter >= CLEAR_DISPLAY_DELAY_CYCLES) // Wait >4.1ms
        next_state = ENTRY_MODE;
      else
        next_state = CLEAR_DISPLAY;
       
    ENTRY_MODE:
      if (delay_counter >= ENTRY_MODE_DELAY_CYCLES) // Wait >53us
        next_state = DISPLAY_ON;
      else
        next_state = ENTRY_MODE;
       
    DISPLAY_ON:
      if (delay_counter >= DISPLAY_ON_DELAY_CYCLES) // Wait >53us
        next_state = RECEIVE_DATA;
      else
        next_state = DISPLAY_ON;
       
    RECEIVE_DATA:
		if (ascii_value == ascii_backspace && ascii_value_valid)
			next_state = CURSOR_LEFT1; // Stay in this state after setup
		else if (ascii_value == ascii_enter && ascii_value_valid)
			next_state = ENTER;
		else
			next_state = RECEIVE_DATA;
			
	  CURSOR_LEFT1:
      if (delay_counter >= FUNCTION_SET1_DELAY_CYCLES) // Wait >53us
        next_state = REPLACE_DATA;
      else
        next_state = CURSOR_LEFT1;
	  
	  REPLACE_DATA:
      if (delay_counter >= FUNCTION_SET1_DELAY_CYCLES) // Wait >53us
        next_state = CURSOR_LEFT2;
      else
        next_state = REPLACE_DATA;
	  
	  CURSOR_LEFT2:
      if (delay_counter >= FUNCTION_SET1_DELAY_CYCLES) // Wait >53us
        next_state = RECEIVE_DATA;
      else
        next_state = CURSOR_LEFT2;
		  
	  ENTER:
      if (delay_counter >= FUNCTION_SET1_DELAY_CYCLES) // Wait >53us
        next_state = RECEIVE_DATA;
      else
        next_state = ENTER;
      
    default:
      next_state = WAIT_VDD;
  endcase
end


//  State and Delay Counter Update Logic
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    current_state <= WAIT_VDD;
    delay_counter <= 20'd0;
    enable <= 1'b0;
  end
  else if (current_state == RECEIVE_DATA) begin
    if (ascii_value!=ascii_backspace && ascii_value!=ascii_enter)begin
		if (ascii_value_valid) begin
			enable <= 1'b1;
		end 
		else if (enable == 1'b1)
		begin
		      if ((delay_counter >= ENABLE_DELAY_CYCLES) &&
          (delay_counter < (ENABLE_DELAY_CYCLES + ENABLE_HIGH_CYCLES)))
              enable <= 1'b1;  // Enable high after delay
           else
              enable <= 1'b0;  // Enable low otherwise
		end
		else
			enable <= 1'b0;
	  end
	  else if (ascii_value_valid) begin
	     current_state <= next_state;
        delay_counter <= 20'd0;
        enable <= 1'b0;
	  end 
	end

//  else if (current_state == REPLACE_DATA) begin
////      if (delay_counter== 20'd0) begin
//			enable <= 1'b1;
//		end 
//		else if (enable == 1'b1)
//		begin
//		      if ((delay_counter >= ENABLE_DELAY_CYCLES) &&
//          (delay_counter < (ENABLE_DELAY_CYCLES + ENABLE_HIGH_CYCLES)))
//              enable <= 1'b1;  // Enable high after delay
//           else
//              enable <= 1'b0;  // Enable low otherwise
//		end
//		else
////			enable <= 1'b0;
//  end
  else begin
    if (current_state == next_state) begin
      delay_counter <= delay_counter + 20'd1;
     
      // Enable signal control within each state
      // After 500ns delay, enable goes high for 800ns, then low
      if ((delay_counter >= ENABLE_DELAY_CYCLES) && (delay_counter < (ENABLE_DELAY_CYCLES + ENABLE_HIGH_CYCLES)))
        enable <= 1'b1;  // Enable high after delay
      else
        enable <= 1'b0;  // Enable low otherwise
    end
    else begin
      current_state <= next_state;
      delay_counter <= 20'd0;
      enable <= 1'b0;
    end
  end
end


// LCD DRIVER
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    lcd_display_code <= 8'h00;
    reg_sel <= 1'b0;
    read_write <= 1'b0;
  end
  else begin
    case (current_state)
      WAIT_VDD: begin
        lcd_display_code <= 8'h00;
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
     
      FUNCTION_SET1, FUNCTION_SET2, FUNCTION_SET3: begin
        lcd_display_code <= 8'h38; // Function set 
        reg_sel <= 1'b0;           // Command mode (RS=0)
        read_write <= 1'b0;        // Write operation
      end
     
      DISPLAY_OFF: begin
        lcd_display_code <= 8'h08; // Display off
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
     
      CLEAR_DISPLAY: begin
        lcd_display_code <= 8'h01; // Clear display
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
     
      ENTRY_MODE: begin
        lcd_display_code <= 8'h06; // Entry mode set
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
     
      DISPLAY_ON: begin
        lcd_display_code <= 8'h0F; // Display on, cursor off, blink off
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
     
      RECEIVE_DATA: begin
        if (ascii_value_valid && ascii_value!=ascii_backspace) begin
          lcd_display_code <= next_lcd_display_code;
          reg_sel <= 1'b1;    // Data mode
          read_write <= 1'b0; // Write operation
        end
//		  if (ascii_value==ascii_backspace) begin
//		    lcd_display_code <= 8'h00;
//          reg_sel <= 1'b0;    // Data mode
//          read_write <= 1'b0; // Write operation
//		  end
		  
      end
		
		CURSOR_LEFT1: begin
        lcd_display_code <= cursor_left_lcd; // Display on, cursor off, blink off
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
		REPLACE_DATA: begin
        lcd_display_code <= space_lcd; // Display on, cursor off, blink off
        reg_sel <= 1'b1;
        read_write <= 1'b0;
      end
		CURSOR_LEFT2: begin
        lcd_display_code <= cursor_left_lcd; // Display on, cursor off, blink off
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
		
		ENTER: begin
        lcd_display_code <= 8'hC0; // Display on, cursor off, blink off
        reg_sel <= 1'b0;
        read_write <= 1'b0;
      end
     
      default: begin
        lcd_display_code <= eight_lcd;
        reg_sel <= 1'b1;
        read_write <= 1'b0;
      end
    endcase
  end
end

assign got_to_left1= (next_state == CURSOR_LEFT1);
assign got_to_left2= (current_state==CURSOR_LEFT2);

endmodule