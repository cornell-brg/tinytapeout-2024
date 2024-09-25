//========================================================================
// PairTripleDetectorV1_GL
//========================================================================

`ifndef PAIR_TRIPLE_DETECTOR_V1_GL_V
`define PAIR_TRIPLE_DETECTOR_V1_GL_V

module PairTripleDetectorV1_GL
(
  input  wire in0,
  input  wire in1,
  input  wire in2,
  output wire out
);

  //''' ACTIVITY '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement pair/triple detector using explicit gate-level modeling
  //>'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  wire w, x, y;

  or ( w,   in0, in1 );
  and( x,   in0, in1 );
  and( y,   w,   in2 );
  or ( out, y,   x   );

  //<'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

endmodule

`endif /* PAIR_TRIPLE_DETECTOR_V1_GL_V */

