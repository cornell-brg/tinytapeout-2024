`ifndef UTILITIES_SV
`define UTILITIES_SV
`timescale 1ns/1ps
module utilities
(
  output logic clk,
  output logic rst
);

  initial clk = 1'b1;

  // Controlling clock signals
  always #5 clk = ~clk; // introducing a slowed down clock


  // Error count

  logic failed = 0;

  // This variable holds the +test-case command line argument indicating
  // which test cases to run.

  string vcd_filename;
  int n = 0;
  initial begin

    if ( !$value$plusargs( "test-case=%d", n ) )
      n = 0;

    if ( $value$plusargs( "dump-vcd=%s", vcd_filename ) ) begin
      $dumpfile(vcd_filename);
      $dumpvars();
    end

  end

  // Always call $urandom with this seed variable to ensure that random
  // test cases are both isolated and reproducible.

  // verilator lint_off UNUSEDSIGNAL
  int seed = 32'hdeadbeef;
  // verilator lint_on UNUSEDSIGNAL

  // Cycle counter with timeout check

  int cycles;

  always @( posedge clk ) begin

    if ( rst )
      cycles <= 0;
    else
      cycles <= cycles + 1;

    if ( cycles > 10000000 ) begin
      $display( "\nERROR (cycles=%0d): timeout!", cycles );
      $finish;
    end

  end

  //----------------------------------------------------------------------
  // test_bench_begin
  //----------------------------------------------------------------------
  // We start with a #1 delay so that all tasks will essentially start at
  // #1 after the rising edge of the clock.
  // test_bench_begin

  task test_bench_begin( string filename );
    $write({"\n",filename});
    #1;
  endtask

  //----------------------------------------------------------------------
  // test_bench_end
  //----------------------------------------------------------------------

  task test_bench_end();
    $write("\n");
    if ( t.n == 0 )
      $write("\n");
    $finish;
  endtask

  //----------------------------------------------------------------------
  // test_case_begin
  //----------------------------------------------------------------------

  task test_case_begin( string taskname );
    $write({"\n",taskname," "});
    if ( t.n != 0 )
      $write("\n");

    seed = 32'hdeadbeef;
    failed = 0;

    rst = 1;
    #30;
    rst = 0;
  endtask

endmodule

`define CHECK_EQ( __dut, __ref )                             \
  if ( __ref !== ( __ref ^ __dut ^ __ref ) ) begin           \
    if ( t.n != 0 )                                          \
      $display( {"\nERROR (cycle=%0d): %s != %s (%b != %b)"},\
                t.cycles, "__dut", "__ref", __dut, __ref );  \
    else                                                     \
      $write( {"FAILED"} );                                  \
    t.failed = 1;                                            \
  end                                                        \
  else begin                                                 \
    if ( t.n == 0 )                                          \
      $write(".");                                           \
  end                                                        \

`endif