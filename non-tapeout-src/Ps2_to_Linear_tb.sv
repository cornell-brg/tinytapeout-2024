
module Top();
  logic       dut_clk;
  logic       dut_rst;
  logic [7:0] dut_ps2_value;
  logic       dut_ps2_valid;
  logic [5:0] dut_linear_value;
  logic       dut_linear_valid;

  utilities t(
    .clk(dut_clk),
    .rst(dut_rst)
  );

  Ps2_to_Linear converter(
    .ps2_value(dut_ps2_value),
    .ps2_valid(dut_ps2_valid),
    .linear_value(dut_linear_value),
    .linear_valid(dut_linear_valid)
  );  

  task verify_letter(string letter);
    dut_ps2_value = keyboard_pkg::letter_to_scancode(letter);
    dut_ps2_valid = 1;
    @(posedge dut_clk);
    `CHECK_EQ(dut_linear_value, linear_pkg::letter_to_linear_code(letter));
    `CHECK_EQ(dut_linear_valid, 1);
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
