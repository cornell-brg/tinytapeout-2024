`ifndef PS2TOLCD_TB_SV
`define PS2TOLCD_TB_SV
`timescale 1ns/1ps
`include "keyboard.sv"
import keyboard_pkg::*;
import lcd_pkg::*;

module Top();
  logic       dut_clk_input;
  logic       dut_rst_input;
  logic       dut_encode_input;
  logic       dut_keymode_input;
  logic       dut_ps2_clk_input;
  logic       dut_ps2_data_input;

  logic [7:0] dut_lcd_display_code_output;
  logic       dut_reg_sel_output;
  logic       dut_read_write_output;
  logic       dut_enable_output;
  logic       dut_rst_output_output;


  // PS2 Collector -> Encrypter
  logic  [7:0]   dut_received_ps2_keycode;
  logic          dut_ps2_valid;

  // Encrypter -> ASCII Converter
  logic  [5:0]   dut_encrypted_keycode;
  logic          dut_encrypted_valid;

  // ASCII Converter -> LCD Converter
  logic  [7:0]   dut_ascii_keycode;
  logic          dut_ascii_valid;


  localparam VDD_DELAY_CYCLES = 800000;        // >15ms after VDD > 4.5V (15ms = 750,000 cycles)
  localparam FUNCTION_SET1_DELAY_CYCLES = 210000; // >4.1ms (4.1ms = 205,000 cycles)
  localparam FUNCTION_SET2_DELAY_CYCLES = 210000;   // >100us (100us = 5,000 cycles)
  localparam DISPLAY_OFF_DELAY_CYCLES = 210000;    // >53us (53us = 2,650 cycles)
  localparam CLEAR_DISPLAY_DELAY_CYCLES = 800000; // >4.1ms (4.1ms = 205,000 cycles)
  localparam ENTRY_MODE_DELAY_CYCLES = 210000;     // >53us (53us = 2,650 cycles)
  localparam DISPLAY_ON_DELAY_CYCLES = 210000;     // >53us (53us = 2,650 cycles)

  // Enable signal timing
  localparam ENABLE_DELAY_CYCLES = 50;         // 500ns (25 cycles at 20ns per cycle)
  localparam ENABLE_HIGH_CYCLES = 80;          // 800ns (minimum enable high time)


    Keyboard k( 
      .clk(dut_clk_input),
      .rst(dut_rst_input),
      .ps2_clk(dut_ps2_clk_input),
      .ps2_data(dut_ps2_data_input)
    );

    utilities t(
      .clk(dut_clk_input),
      .rst(dut_rst_input)
    );

    Ps2DataCollection collector
    (
      .clk(dut_clk_input),
      .rst(dut_rst_input),
      .ps2_clk(dut_ps2_clk_input),
      .ps2_data(dut_ps2_data_input),
      .received_data(dut_received_ps2_keycode),
      .valid(dut_ps2_valid)
    );

    CaeserCipher encypter
    (
      .clk(dut_clk_input),
      .keymode(dut_rst_input),
      .encode(dut_encode_input), //1 for encode, 0 for decode
      .valid(dut_ps2_valid),
      .received_data(dut_received_ps2_keycode),
      .encrypted_value(dut_encrypted_keycode),
      .encrypted_value_valid(dut_encrypted_valid)
    );

    Linear_to_ASCII transformer
    (
      .clk(dut_clk_input),
      .valid(dut_encrypted_valid),
      .received_data(dut_encrypted_keycode),
      .ascii_value(dut_ascii_keycode),
      .ascii_value_valid(dut_ascii_valid_wire)
    );


    LCD_display converter(
      .clk(dut_clk_input),
      .rst(dut_rst_input),
      .valid(dut_ascii_valid),
      .received_data(dut_ascii_keycode),
      .lcd_display_code(dut_lcd_display_code_output),
      .reg_sel(dut_reg_sel_output),
      .read_write(dut_read_write_output),
      .enable(dut_enable_output),
      .rst_output(dut_rst_output_output)
    );

    task verify_lcd_setup_states();
      //verify wait state
        for (int i = 0; i < VDD_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h0);
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 0);
        end

      //verify function set 1
        for (int i = 0; i < FUNCTION_SET1_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h3); 
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 1);
        end

      //verify function set 2
        for (int i = 0; i < FUNCTION_SET2_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h3); 
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 1);
        end

      //verify function set 3
        for (int i = 0; i < FUNCTION_SET3_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h3); 
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 1);
        end
        
        //verify display off
        for (int i = 0; i < DISPLAY_OFF_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h8); 
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 1);
        end

        //verify display off
        for (int i = 0; i < CLEAR_DISPLAY_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h1); 
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 0);
        end

        // verify entry mode
        for (int i = 0; i < ENTRY_MODE_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h1);
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 0);
        end


        // verify display on
        for (int i = 0; i < DISPLAY_ON_DELAY_CYCLES; i++) begin
            @(posedge dut_clk_input);
            `CHECK_EQ(dut_lcd_display_code_output, 4'h1);
            `CHECK_EQ(dut_reg_sel_output, 0);
            `CHECK_EQ(dut_read_write_output, 0);
            `CHECK_EQ(dut_enable_output, 0);
        end

    endtask 

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
    `CHECK_EQ(received_parity, ^received_data);
    
  
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

  task verify_Ps2DataCollection(string letter);
    fork
      k.keypress(letter);
      verify_collected_data(keyboard_pkg::letter_to_scancode(letter));
    join
  endtask
  
  task verify_LCD_display_code(input logic [7:0] expected_data);
    @(posedge dut_clk_input);
    `CHECK_EQ(dut_lcd_display_code_output, expected_data); //check on the positive edge
    `CHECK_EQ(dut_enable_output, 1); //check enable
    `CHECK_EQ(dut_read_write_output, 0); //check read_write
    `CHECK_EQ(dut_reg_sel_output, 1); //check reg_sel
  endtask


  task verify_letter(string letter);
    verify_Ps2DataCollection(letter);
  endtask

  initial begin
    verify_lcd_setup_states();
    verify_letter("c");
    $finish;
  end

endmodule 

`endif