`ifndef KEYBOARD_SV
`define KEYBOARD_SV
`timescale 1ns/1ps
`include "utilities.sv"
import keyboard_pkg::*;

module Keyboard (
  input  logic clk,
  input  logic rst,
  output logic ps2_clk,
  output logic ps2_data
);

  // Starting both data and clock high
  initial begin
    ps2_data = 1'b1;
    ps2_clk  = 1'b1;
    $display("Starting simulation");
  end

  // localparam real HALF_PERIOD = (1_000_000_000.0 / (2.0 * PS2_CLK_FREQ_HZ));
  // localparam int DELAY = HALF_PERIOD;


  task send_bit(input logic bit_value);
  begin
    ps2_data = bit_value;
    ps2_clk = 0; //sent on the falling edge
    #(DELAY);
    ps2_clk = 1;
    #(DELAY);
  end
  endtask


  task breakcode();
    logic [7:0] break_hex_code;
    integer i;
    begin 
      break_hex_code = 8'hF0;
      for (i = 0; i < 8; i = i + 1)
        send_bit(break_hex_code[i]);
    end
  endtask

  task lettercode(string letter);
    logic [7:0] data;
    integer i;
    logic parity;
  begin
    data = keyboard_pkg::letter_to_scancode(letter);
    parity = ^data;
    #(DELAY * 4);
    
    // start bit
    send_bit(0);
    // data bits
    for (i = 0; i < 8; i = i + 1)
      send_bit(data[i]);
    // parity bit
    send_bit(parity);
    // stop bit
    send_bit(1);
  end
  endtask

  task keypress(string letter);
    lettercode(letter);
    breakcode();
    lettercode(letter);
  endtask

endmodule

`endif