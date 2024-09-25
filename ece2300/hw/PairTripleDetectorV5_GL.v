//========================================================================
// PairTripleDetectorV5_GL
//========================================================================

`ifndef PAIR_TRIPLE_DETECTOR_V5_GL_V
`define PAIR_TRIPLE_DETECTOR_V5_GL_V

module PairTripleDetectorV5_GL
(
  input  wire in0,
  input  wire in1,
  input  wire in2,
  output wire out
);

  // AND gates for each row in the truth table

  wire min3, min5, min6, min7;

  // assign min0 = ~in0 & ~in1 & ~in2;
  // assign min1 = ~in0 & ~in1 &  in2;
  // assign min2 = ~in0 &  in1 & ~in2;
  assign min3 = ~in0 &  in1 &  in2;

  // assign min4 =  in0 & ~in1 & ~in2;
  assign min5 =  in0 & ~in1 &  in2;
  assign min6 =  in0 &  in1 & ~in2;
  assign min7 =  in0 &  in1 &  in2;

  // OR together all wires where output in truth table is one

  assign out = min3 | min5 | min6 | min7;

endmodule

`endif /* PAIR_TRIPLE_DETECTOR_V5_GL_V */

