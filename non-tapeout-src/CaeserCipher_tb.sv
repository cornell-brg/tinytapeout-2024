// Caeser Cipher Unit Test Bench 

module Top();
	logic       dut_clk;
  logic       dut_encode; // 1 for encode, 0 for decode
  logic       dut_keymode; // 1 for entering a key
	logic       dut_unciphered_valid;
	logic [5:0] dut_unciphered_value;
	logic [5:0] dut_ciphered_value;
  logic       dut_ciphered_valid;

// local , used for intermediary steps
  logic [5:0] key = 6'd0;
  logic [5:0] digitized_char;
  logic [5:0] expected_val;

  logic [5:0] double_alphabet[0:71]; // 2 * 36 = 72 elements
  
  utilities t(
    .clk(dut_clk),
    .rst(dut_rst)
  );

  CaeserCipher encrypter(
    .encode(dut_encode), // 1 for encode, 0 for decode
    .keymode(dut_keymode), // 1 for entering a key
	  .unciphered_valid(dut_unciphered_valid),
	  .unciphered_value(dut_unciphered_value),
	  .ciphered_value(dut_ciphered_value),
    .ciphered_valid(dut_ciphered_valid)
  );  


task change_key_value(string character);
  dut_keymode=1;
  dut_unciphered_value = linear_pkg::letter_to_linear_code(character);
  dut_unciphered_valid = 1;
  @(posedge dut_clk); // avoiding race conditions
  dut_keymode = 0;
  dut_unciphered_valid = 0;
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
endtask

task test_character(input logic [5:0] key_val, string character, bit encoding);
  digitized_char = linear_pkg::letter_to_linear_code(character);
  dut_encode = encoding; 
  @(posedge dut_clk);
  //$display("\nLinear version of the letter %s: %d, key is %0d", character, digitized_char, key);
  // set the value testing
  dut_unciphered_value = linear_pkg::letter_to_linear_code(character);
  dut_unciphered_valid = 1;

  if (encoding) //encoding
  begin
    expected_val = double_alphabet[36 + digitized_char - key_val];
    // $display("\nTesting %s: Expected Value: %0d, Dut_ciphered_value: %0d", character, expected_val, dut_ciphered_value);
  end
  else //decoding 
    expected_val = double_alphabet[digitized_char + key_val];
  
  
  @(posedge dut_clk); // removing race condition
  `CHECK_EQ(dut_ciphered_value, expected_val);
  `CHECK_EQ(dut_ciphered_valid, 1);
  $display("(Testing %s: Expected Value: %0d, Dut_ciphered_value: %0d)", character, expected_val, dut_ciphered_value);
  @(posedge dut_clk);
  dut_unciphered_valid = 0;


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
  end

endmodule