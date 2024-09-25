//========================================================================
// PairTripleDetectorV1_GL_adhoc
//========================================================================

`include "PairTripleDetectorV1_GL.v"

module Top();

  // Declare wires which will be connected to the design-under-test. Note
  // that we use "logic" not "wire" in test benches. A "logic" is a more
  // abstract kind of signal than a "wire" in Verilog.

  logic dut_in0;
  logic dut_in1;
  logic dut_in2;
  logic dut_out;

  // Instantiate the design-under-test (DUT) and hook up the ports to the
  // logic signals we just declared.

  PairTripleDetectorV1_GL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .in2 (dut_in2),
    .out (dut_out)
  );

  // An initial block is a special piece of code which starts running at
  // the beginning of a simulation. You should NEVER use an initial block
  // when modeling hardware. But it is perfectly fine to use an initial
  // block in your test benches.

  initial begin

    // These system tasks are used to tell the simulator to output a VCD
    // file which contains waveforms so we can visualize what our
    // hardware design is doing.

    $dumpfile("PairTripleDetector_adhoc_test.vcd");
    $dumpvars;

    // Set input values for all input ports. Then wait 10 units of time.
    // Then we display all of the input and output values. We do this
    // four times with four different sets of input values.

    dut_in0 = 0;
    dut_in1 = 0;
    dut_in2 = 0;
    #10;
    $display( "%b %b %b > %b", dut_in0, dut_in1, dut_in2, dut_out );

    dut_in0 = 0;
    dut_in1 = 1;
    dut_in2 = 1;
    #10;
    $display( "%b %b %b > %b", dut_in0, dut_in1, dut_in2, dut_out );

    dut_in0 = 0;
    dut_in1 = 1;
    dut_in2 = 0;
    #10;
    $display( "%b %b %b > %b", dut_in0, dut_in1, dut_in2, dut_out );

    dut_in0 = 1;
    dut_in1 = 1;
    dut_in2 = 1;
    #10;
    $display( "%b %b %b > %b", dut_in0, dut_in1, dut_in2, dut_out );

  end

endmodule

