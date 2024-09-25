//========================================================================
// PairTripleDetectorV3_GL
//========================================================================

`ifndef PAIR_TRIPLE_DETECTOR_V3_GL_V
`define PAIR_TRIPLE_DETECTOR_V3_GL_V

module PairTripleDetectorV3_GL
(
  input  wire in0,
  input  wire in1,
  input  wire in2,
  output wire out
);

  wire w;
  wire x;
  wire y;

  assign w   = in0 | in1;
  assign x   = in0 & in1;
  assign y   = w   & in2;
  assign out = y   | x;

endmodule

`endif /* PAIR_TRIPLE_DETECTOR_V3_GL_V */

