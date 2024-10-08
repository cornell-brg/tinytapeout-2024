/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

//========================================================================
// PairTripleDetector_GL
//========================================================================

`ifndef TT_UM_NLP52_PAIRTRIPLEDETECTOR_V
`define TT_UM_NLP52_PAIRTRIPLEDETECTOR_V

module tt_um_nlp52_PairTripleDetector (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

PairTripleDetector_GL dut
(
  .in0 (ui_in[0]),
  .in1 (ui_in[1]),
  .in2 (ui_in[2]),
  .out (uo_out[0])
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:1] = 7'b0;
  assign uio_out[7:0] = 8'b0;
  assign uio_oe[7:0] = 8'b0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule


`endif /* PAIR_TRIPLE_DETECTOR_GL_V */

`ifndef PAIR_TRIPLE_DETECTOR_GL_V
`define PAIR_TRIPLE_DETECTOR_GL_V

module PairTripleDetector_GL
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

`endif /* PAIR_TRIPLE_DETECTOR_GL_V */
