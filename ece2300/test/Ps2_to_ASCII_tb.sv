module Top();
  logic       dut_clk;
  logic       dut_rst;
  logic       dut_encode;
  logic       dut_keymode;
  logic [7:0] dut_ps2_value_input;
  logic       dut_ps2_valid_input;
  logic [7:0] dut_ascii_value_output;
  logic       dut_ascii_valid_output;

//local wires for connecting the modules
logic       dut_unciphered_valid;
logic [5:0] dut_unciphered_value;
logic [5:0] dut_ciphered_value;
logic       dut_ciphered_valid;

// Used to ensure correctness 
logic [5:0] double_alphabet[0:71];
logic [5:0] digitized_char;
logic [5:0] expected_val;
logic [7:0] ascii_expected_val;
logic [5:0] key = 6'd0;

//Instantiating modules
utilities t(
  .clk(dut_clk),
  .rst(dut_rst)
);

Ps2_to_Linear converter(
  .ps2_value(dut_ps2_value_input),
  .ps2_valid(dut_ps2_valid_input),
  .linear_value(dut_unciphered_value),
  .linear_valid(dut_unciphered_valid)
);

CaeserCipher encrypter(
  .encode(dut_encode), // 1 for encode, 0 for decode
  .keymode(dut_keymode), // 1 for entering a key
  .unciphered_valid(dut_unciphered_valid),
  .unciphered_value(dut_unciphered_value),
  .ciphered_value(dut_ciphered_value),
  .ciphered_valid(dut_ciphered_valid)
); 

Linear_to_ASCII l(
  .linear_value(dut_ciphered_value),
  .linear_valid(dut_ciphered_valid),
  .ascii_value(dut_ascii_value_output),
  .ascii_valid(dut_ascii_valid_output)
); 

//
always_comb begin
  case(expected_val)
    // Letters A-Z (linear 0-25 → ASCII 65-90)
    6'd0:  ascii_expected_val = 8'd65;  // A
    6'd1:  ascii_expected_val = 8'd66;  // B
    6'd2:  ascii_expected_val = 8'd67;  // C
    6'd3:  ascii_expected_val = 8'd68;  // D
    6'd4:  ascii_expected_val = 8'd69;  // E
    6'd5:  ascii_expected_val = 8'd70;  // F
    6'd6:  ascii_expected_val = 8'd71;  // G
    6'd7:  ascii_expected_val = 8'd72;  // H
    6'd8:  ascii_expected_val = 8'd73;  // I
    6'd9:  ascii_expected_val = 8'd74;  // J
    6'd10: ascii_expected_val = 8'd75;  // K
    6'd11: ascii_expected_val = 8'd76;  // L
    6'd12: ascii_expected_val = 8'd77;  // M
    6'd13: ascii_expected_val = 8'd78;  // N
    6'd14: ascii_expected_val = 8'd79;  // O
    6'd15: ascii_expected_val = 8'd80;  // P
    6'd16: ascii_expected_val = 8'd81;  // Q
    6'd17: ascii_expected_val = 8'd82;  // R
    6'd18: ascii_expected_val = 8'd83;  // S
    6'd19: ascii_expected_val = 8'd84;  // T
    6'd20: ascii_expected_val = 8'd85;  // U
    6'd21: ascii_expected_val = 8'd86;  // V
    6'd22: ascii_expected_val = 8'd87;  // W
    6'd23: ascii_expected_val = 8'd88;  // X
    6'd24: ascii_expected_val = 8'd89;  // Y
    6'd25: ascii_expected_val = 8'd90;  // Z
    
    // Digits 0-9 (linear 26-35 → ASCII 48-57)
    6'd26: ascii_expected_val = 8'd48;  // 0
    6'd27: ascii_expected_val = 8'd49;  // 1
    6'd28: ascii_expected_val = 8'd50;  // 2
    6'd29: ascii_expected_val = 8'd51;  // 3
    6'd30: ascii_expected_val = 8'd52;  // 4
    6'd31: ascii_expected_val = 8'd53;  // 5
    6'd32: ascii_expected_val = 8'd54;  // 6
    6'd33: ascii_expected_val = 8'd55;  // 7
    6'd34: ascii_expected_val = 8'd56;  // 8
    6'd35: ascii_expected_val = 8'd57;  // 9

    6'd36: ascii_expected_val = 8'd32;  // space
    6'd37: ascii_expected_val = 8'd8;   // backspace
    6'd38: ascii_expected_val = 8'd13;  // enter

    default: ascii_expected_val = 8'd63; // '?' for any invalid values
  endcase
end

task change_key_value(string character);
  dut_keymode=1;
  dut_ps2_value_input =  keyboard_pkg::letter_to_scancode(character);
  dut_ps2_valid_input = 1;
  @(posedge dut_clk); // avoiding race conditions
  dut_keymode = 0;
  dut_ps2_valid_input = 0;
  @(posedge dut_clk); // avoiding race conditions
endtask

task test_key_value(string character);
  key = linear_pkg::letter_to_linear_code(character);
  change_key_value(character); 
  test_encoding(key);
  test_decoding(key);
endtask

task test_encoding(input logic [5:0] key_val);
  $display("\nTesting ENCODING with key value: %0d", key_val);
  dut_encode = 1; 
  test_character(key_val, "a", 1);
  test_character(key_val, "b", 1);
  test_character(key_val, "c", 1);
  test_character(key_val, "d", 1);
  test_character(key_val, "e", 1);
  test_character(key_val, "f", 1);
  test_character(key_val, "g", 1);
  test_character(key_val, "h", 1);
  test_character(key_val, "i", 1);
  test_character(key_val, "j", 1);
  test_character(key_val, "k", 1);
  test_character(key_val, "l", 1);
  test_character(key_val, "m", 1);
  test_character(key_val, "n", 1);
  test_character(key_val, "o", 1);
  test_character(key_val, "p", 1);
  test_character(key_val, "q", 1);
  test_character(key_val, "r", 1);
  test_character(key_val, "s", 1);
  test_character(key_val, "t", 1);
  test_character(key_val, "u", 1);
  test_character(key_val, "v", 1);
  test_character(key_val, "w", 1);
  test_character(key_val, "x", 1);
  test_character(key_val, "y", 1);
  test_character(key_val, "z", 1);
  test_character(key_val, "0", 1);
  test_character(key_val, "1", 1);
  test_character(key_val, "2", 1);
  test_character(key_val, "3", 1);
  test_character(key_val, "4", 1);
  test_character(key_val, "5", 1);
  test_character(key_val, "6", 1);
  test_character(key_val, "7", 1);
  test_character(key_val, "8", 1);
  test_character(key_val, "9", 1);
  test_character(key_val, "space", 1);
endtask

task test_decoding(input logic [5:0] key_val);
  $display("\nTesting DECODING with key value: %0d", key_val);
  dut_encode = 0; 
  test_character(key_val, "a", 0);
  test_character(key_val, "b", 0);
  test_character(key_val, "c", 0);
  test_character(key_val, "d", 0);
  test_character(key_val, "e", 0);
  test_character(key_val, "f", 0);
  test_character(key_val, "g", 0);
  test_character(key_val, "h", 0);
  test_character(key_val, "i", 0);
  test_character(key_val, "j", 0);
  test_character(key_val, "k", 0);
  test_character(key_val, "l", 0);
  test_character(key_val, "m", 0);
  test_character(key_val, "n", 0);
  test_character(key_val, "o", 0);
  test_character(key_val, "p", 0);
  test_character(key_val, "q", 0);
  test_character(key_val, "r", 0);
  test_character(key_val, "s", 0);
  test_character(key_val, "t", 0);
  test_character(key_val, "u", 0);
  test_character(key_val, "v", 0);
  test_character(key_val, "w", 0);
  test_character(key_val, "x", 0);
  test_character(key_val, "y", 0);
  test_character(key_val, "z", 0);
  test_character(key_val, "0", 0);
  test_character(key_val, "1", 0);
  test_character(key_val, "2", 0);
  test_character(key_val, "3", 0);
  test_character(key_val, "4", 0);
  test_character(key_val, "5", 0);
  test_character(key_val, "6", 0);
  test_character(key_val, "7", 0);
  test_character(key_val, "8", 0);
  test_character(key_val, "9", 0);
  test_character(key_val, "space", 0);
endtask

task test_character(input logic [5:0] key_val, string character, bit encoding);
  digitized_char = linear_pkg::letter_to_linear_code(character);
  dut_encode = encoding; 
  @(posedge dut_clk);
  dut_ps2_value_input= keyboard_pkg::letter_to_scancode(character);
  dut_ps2_valid_input = 1;

  if (dut_ps2_value_input < 6'd37) begin
    if (encoding)
      ascii_expected_val = double_alphabet[37 + digitized_char - key_val];
    else  
      ascii_expected_val = double_alphabet[digitized_char + key_val];
  end
  else
      ascii_expected_val = dut_unciphered_value;
  
  
  @(posedge dut_clk); // removing race condition
  `CHECK_EQ(dut_ascii_value_output, ascii_expected_val);
  `CHECK_EQ(dut_ascii_valid_output, 1);
  @(posedge dut_clk);
  dut_ps2_valid_input = 0;

endtask



initial begin
  //initialize the double alphabet to be used rest in the rest of testing
  for (int i = 0; i < 72; i++) begin
    double_alphabet[i] = i % 36; // Maps to 0-35 repeating CORRECT
  end

  test_key_value("a");
  test_key_value("b");
  test_key_value("c");
  test_key_value("d");
  test_key_value("e");
  test_key_value("f");
  test_key_value("g");
  test_key_value("h");
  test_key_value("i");
  test_key_value("j");
  test_key_value("k");
  test_key_value("l");
  test_key_value("m");
  test_key_value("n");
  test_key_value("o");
  test_key_value("p");
  test_key_value("q");
  test_key_value("r");
  test_key_value("s");
  test_key_value("t");
  test_key_value("u");
  test_key_value("v");
  test_key_value("w");
  test_key_value("x");
  test_key_value("y");
  test_key_value("z");
  test_key_value("0");
  test_key_value("1");
  test_key_value("2");
  test_key_value("3");
  test_key_value("4");
  test_key_value("5");
  test_key_value("6");
  test_key_value("7");
  test_key_value("8");
  test_key_value("9");
  test_key_value("space");
  end

endmodule
