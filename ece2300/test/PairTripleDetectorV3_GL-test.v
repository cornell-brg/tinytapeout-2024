//========================================================================
// PairTripleDetectorV3_GL-test
//========================================================================

`include "ece2300-test.v"
`include "PairTripleDetectorV3_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk;
  logic reset;
  // verilator lint_on UNUSED

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic dut_in0;
  logic dut_in1;
  logic dut_in2;
  logic dut_out;

  PairTripleDetectorV3_GL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .in2 (dut_in2),
    .out (dut_out)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic in0,
    input logic in1,
    input logic in2,
    input logic out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_in2 = in2;

      #8;

      if ( t.n != 0 )
        $display( "%3d: %b %b %b > %b", t.cycles,
                  dut_in0, dut_in1, dut_in2, dut_out );

      `ECE2300_CHECK_EQ( dut_out, out );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    check( 0, 0, 0, 0 );
    check( 0, 1, 1, 1 );
    check( 0, 1, 0, 0 );
    check( 1, 1, 1, 1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_exhaustive
  //----------------------------------------------------------------------

  task test_case_2_exhaustive();
    t.test_case_begin( "test_case_2_exhaustive" );

    check( 0, 0, 0, 0 );
    check( 0, 0, 1, 0 );
    check( 0, 1, 0, 0 );
    check( 0, 1, 1, 1 );

    check( 1, 0, 0, 0 );
    check( 1, 0, 1, 1 );
    check( 1, 1, 0, 1 );
    check( 1, 1, 1, 1 );

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_exhaustive();

    t.test_bench_end();
  end

endmodule
