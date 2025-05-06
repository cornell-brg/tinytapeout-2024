`ifndef PS2DATACOLLECTION_TB_SV
`define PS2DATACOLLECTION_TB_SV
`timescale 1ns/1ps

module Top();
  logic dut_clk;
  logic dut_rst;
  logic dut_ps2_clk;
  logic dut_ps2_data;
  logic [7:0] dut_received_data;
  logic dut_valid;

  Keyboard k( 
    .clk(dut_clk),
    .rst(dut_rst),
    .ps2_clk(dut_ps2_clk),
    .ps2_data(dut_ps2_data)
  );

  utilities t(
    .clk(dut_clk),
    .rst(dut_rst)
  );

  Ps2DataCollection p(
    .clk(dut_clk),
    .rst(dut_rst),
    .ps2_clk(dut_ps2_clk),
    .ps2_data(dut_ps2_data),
    .received_data(dut_received_data),
    .valid(dut_valid)
  );

  task verify_breakcode();
    logic [7:0] received_data;
    logic [7:0] breakcode = 8'hF0;

    for(int i = 0; i < 8; i++) begin
      @(posedge dut_ps2_clk);
      received_data = {dut_ps2_data, received_data[7:1]}; // Right shift, new bit goes to MSB
      `CHECK_EQ(dut_ps2_data, breakcode[i]);
    end
   $display("Breakcode recieved");
  endtask

  task verify_ps2_code(input logic [7:0] expected_data);
    logic received_parity;
    logic [7:0] received_data;

    // Wait for start bit (0)
    @(posedge dut_ps2_clk);
    `CHECK_EQ(dut_ps2_data, 0); //check on the positive edge

    // Receive 8 data bits, shifting in LSB first
    for(int i = 0; i < 8; i++) begin
        @(posedge dut_ps2_clk);
        received_data = {dut_ps2_data, received_data[7:1]}; // Right shift, new bit goes to MSB
        `CHECK_EQ(dut_ps2_data, expected_data[i]);
    end
    
    // Check parity
    @(posedge dut_ps2_clk);
    received_parity = dut_ps2_data;
    
  
    @(posedge dut_valid);
    `CHECK_EQ(dut_received_data, expected_data);
    `CHECK_EQ(dut_ps2_data, 1);
    @(posedge dut_clk); //data should go back to being invalid
    #1 //eliminating race conditions
    `CHECK_EQ(dut_valid, 0);
  
    @(posedge dut_ps2_clk);
  
  endtask

  task wait_for_break();
    @(posedge dut_ps2_clk); //start bit shouldve been recognized
    @(posedge dut_ps2_clk); //data bit 1 shouldve been collected
    @(posedge dut_ps2_clk); //data bit 2 shouldve been collected
    @(posedge dut_ps2_clk); //data bit 3 shouldve been collected
    @(posedge dut_ps2_clk); //data bit 4 shouldve been collected
    @(posedge dut_ps2_clk); //data bit 5 shouldve been collected
    @(posedge dut_ps2_clk); //data bit 6 shouldve been collected
    @(posedge dut_ps2_clk); //data bit 7 shouldve been collected
    @(posedge dut_ps2_clk); //data bit 8 shouldve been collected
    @(posedge dut_ps2_clk); //parity bit  shouldve been collected
    @(posedge dut_ps2_clk); //stop bit shouldve been recognized
  endtask

  task verify_collected_data(input logic [7:0] expected_data);
    wait_for_break();
    verify_breakcode();
    verify_ps2_code(expected_data);
    $display("verified");
  endtask

  task verify_letter(string letter);
    fork
      k.keypress(letter);
      verify_collected_data(keyboard_pkg::letter_to_scancode(letter));
    join
  endtask

  task verify_alphabet();
    verify_letter("a");
    verify_letter("b");
    verify_letter("c");
    verify_letter("d");
    verify_letter("e");
    verify_letter("f");
    verify_letter("g");
    verify_letter("h");
    verify_letter("i");
    verify_letter("j");
    verify_letter("k");
    verify_letter("l");
    verify_letter("m");
    verify_letter("n");
    verify_letter("o");
    verify_letter("p");
    verify_letter("q");
    verify_letter("r");
    verify_letter("s");
    verify_letter("t");
    verify_letter("u");
    verify_letter("v");
    verify_letter("w");
    verify_letter("x");
    verify_letter("y");
    verify_letter("z");
    verify_letter("0");
    verify_letter("1");
    verify_letter("2");
    verify_letter("3");
    verify_letter("4");
    verify_letter("5");
    verify_letter("6");
    verify_letter("7");
    verify_letter("8");
    verify_letter("9");
    verify_letter("space");
    verify_letter("backspace");
    verify_letter("enter");
  endtask

  initial begin
    verify_alphabet();
    $finish;
  end


endmodule 

`endif