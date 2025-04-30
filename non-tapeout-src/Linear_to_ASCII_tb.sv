
module Top();
  logic       dut_clk;
  logic       dut_rst;
  logic [5:0] dut_linear_value;
  logic       dut_linear_valid;
  logic [7:0] dut_ascii_value;
  logic       dut_ascii_valid;

  utilities t(
    .clk(dut_clk),
    .rst(dut_rst)
  );

  Linear_to_ASCII l(
    .linear_value(dut_linear_value),
    .linear_valid(dut_linear_valid),
    .ascii_value(dut_ascii_value),
    .ascii_valid(dut_ascii_valid)
  );  

  task verify_letter(string letter);
    dut_linear_value = linear_pkg::letter_to_linear_code(letter);
    dut_linear_valid = 1;
    @(posedge dut_clk);
    `CHECK_EQ(dut_ascii_value, ascii_pkg::letter_to_ascii_code(letter));
    `CHECK_EQ(dut_ascii_valid, 1);
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
  endtask

initial begin
    verify_alphabet();
    $finish;
  end

endmodule
