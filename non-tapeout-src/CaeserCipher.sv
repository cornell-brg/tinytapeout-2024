module CaeserCipher(
  input  logic       encode, // 1 for encode, 0 for decode
  input  logic       keymode, // 1 for entering a key
	input  logic       unciphered_valid,
	input  logic [5:0] unciphered_value,
	output logic [5:0] ciphered_value,
  output logic       ciphered_valid
);

logic [5:0] key = 6'd0;

localparam linear_a = 6'd0;
localparam linear_9 = 6'd35;


always_comb
begin
  if (encode == 1'b1 && keymode ==1'b0) //// ENCRYPTING
  begin
    if (unciphered_value >= linear_a && unciphered_value <= linear_9 && (unciphered_value < key))
      ciphered_value = linear_9 - (key - (unciphered_value - linear_a)) + 1;
    else if (unciphered_value >= linear_a && unciphered_value <= linear_9)
      ciphered_value = unciphered_value - key;
  end
  else if (keymode ==1'b0) //// DECRYPTING
  begin 
    if (unciphered_value >= linear_a && unciphered_value <= linear_9 && (unciphered_value+key > linear_9))
      ciphered_value = linear_a + ((unciphered_value + key) - linear_9 - 1);
    else if (unciphered_value >= linear_a && unciphered_value <= linear_9)
      ciphered_value = unciphered_value + key;
  end
  else ////KEYMODE
    key = unciphered_value; //assigned a value a-9
end

assign ciphered_valid = unciphered_valid;

endmodule
