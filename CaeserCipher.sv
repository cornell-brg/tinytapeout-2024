module CaeserCipher(
  input  logic       clk,
  input  logic       encode, // 1 for encode, 0 for decode
  input  logic       keymode, // 1 for entering a key
	input  logic       unciphered_valid,
	input  logic [5:0] unciphered_value,
	output logic [5:0] ciphered_value,
  output logic       ciphered_valid
);

logic [5:0] key = 6'b0;

localparam linear_a = 6'd0;
localparam linear_space = 6'd36;
localparam linear_backspace = 6'd37;
localparam linear_enter = 6'd38;



always_comb
begin
  ciphered_value= unciphered_value;
  if (keymode ==1'b0 && unciphered_value != linear_backspace && unciphered_value != linear_enter) begin 
  ciphered_value= unciphered_value;
  if (encode == 1'b1 && keymode ==1'b0) //// ENCRYPTING
  begin
    if (unciphered_value >= linear_a && unciphered_value <= linear_space && (unciphered_value < key))
      ciphered_value = linear_space - (key - (unciphered_value - linear_a)) + 1;
    else if (unciphered_value >= linear_a && unciphered_value <= linear_space) begin
      ciphered_value = unciphered_value - key;
		end
  end
  else if (keymode ==1'b0) //// DECRYPTING
  begin 
    if (unciphered_value >= linear_a && unciphered_value <= linear_space && (unciphered_value+key > linear_space))
      ciphered_value = linear_a + ((unciphered_value + key) - linear_space - 1);
    else if (unciphered_value >= linear_a && unciphered_value <= linear_space) begin
      ciphered_value = unciphered_value + key;
	 end
  end
  end
end


always_ff @(posedge clk)
begin 
  if (keymode ==1'b1 && unciphered_value != linear_backspace && unciphered_value != linear_enter)
	key <= unciphered_value;
end


assign ciphered_valid = (unciphered_valid && keymode==1'b0);
endmodule
