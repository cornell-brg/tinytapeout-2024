module Top (
  input  logic       clk_input,
  input  logic       rst_input,

  input  logic       encode_input,
  input  logic       keymode_input,

  input  logic       ps2_clk_input,
  input  logic       ps2_data_input,
  
  output logic [7:0] lcd_display_code_output,
  output logic       reg_sel_output,
  output logic       read_write_output,
  output logic       enable_output,
  output logic       rst_output_output
);

// PS2 Collector -> Linear Converter
logic  [7:0]   received_ps2_keycode_wire;
logic          ps2_valid_wire;

// Linear Converter -> Encrypter
logic [5:0]   unciphered_value_wire;
logic         unciphered_valid_wire

// Encrypter -> ASCII Converter
logic [5:0]   ciphered_value_wire;
logic         ciphered_valid_wire

// ASCII Converter -> LCD Converter
logic  [7:0]   ascii_value_wire;
logic          ascii_valid_wire;


Ps2DataCollection collector
(
  .clk(clk_input),
  .rst(rst_input),
  .ps2_clk(ps2_clk_input),
  .ps2_data(ps2_data_input),
  .received_data(received_ps2_keycode_wire),
  .valid(ps2_valid_wire)
);

Ps2_to_Linear converter(
  .ps2_value(received_ps2_keycode_wire),
  .ps2_valid(ps2_valid_wire),
  .linear_value(unciphered_value_wire),
  .linear_valid(unciphered_valid_wire)
);

CaeserCipher encrypter(
  .encode(encode_wire), // 1 for encode, 0 for decode
  .keymode(keymode_wire), // 1 for entering a key
  .unciphered_valid(unciphered_valid_wire),
  .unciphered_value(unciphered_value_wire),
  .ciphered_value(ciphered_value_wire),
  .ciphered_valid(ciphered_valid_wire)
); 

Linear_to_ASCII l(
  .linear_value(ciphered_value_wire),
  .linear_valid(ciphered_valid_wire),
  .ascii_value(ascii_value_wire),
  .ascii_valid(ascii_valid_wire)
); 

LCD_display converter(
  .clk(clk_input),
  .rst(rst_input),
  .ascii_value_valid(ascii_valid_wire),
  .ascii_value(ascii_value_wire),
  .lcd_display_code(lcd_display_code_output),
  .reg_sel(reg_sel_output),
  .read_write(read_write_output),
  .enable(enable_output),
  .rst_output(rst_output_output)
);'


endmodule
