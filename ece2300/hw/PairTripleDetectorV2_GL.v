//========================================================================
// PairTripleDetectorV2_GL
//========================================================================

`ifndef PAIR_TRIPLE_DETECTOR_V2_GL_V
`define PAIR_TRIPLE_DETECTOR_V2_GL_V

module PairTripleDetectorV2_GL
(
  input  wire in0,
  input  wire in1,
  input  wire in2,
  output wire out
);

  // NOT gates to create complement of each input

  wire in0_b, in1_b, in2_b;

  not( in0_b, in0 );
  not( in1_b, in1 );
  not( in2_b, in2 );

  // AND gates for each row in the truth table

  wire min3, min5, min6, min7;

  // and( min0, in0_b, in1_b, in2_b );
  // and( min1, in0_b, in1_b, in2   );
  // and( min2, in0_b, in1,   in2_b );
  and( min3, in0_b, in1,   in2   );

  // and( min4, in0,   in1_b, in2_b );
  and( min5, in0,   in1_b, in2   );
  and( min6, in0,   in1,   in2_b );
  and( min7, in0,   in1,   in2   );

  // OR together all wires where output in truth table is one

  or( out, min3, min5, min6, min7 );

endmodule

`endif /* PAIR_TRIPLE_DETECTOR_V2_GL_V */

