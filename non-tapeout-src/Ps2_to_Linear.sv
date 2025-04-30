module Ps2_to_Linear(
  input  logic [7:0] ps2_value,
  input  logic       ps2_valid,
  output logic [5:0] linear_value,
  output logic       linear_valid
);

  // Linear codes 
  localparam linear_a = 6'd0;
  localparam linear_b = 6'd1;
  localparam linear_c = 6'd2;
  localparam linear_d = 6'd3;
  localparam linear_e = 6'd4;
  localparam linear_f = 6'd5;
  localparam linear_g = 6'd6;
  localparam linear_h = 6'd7;
  localparam linear_i = 6'd8;
  localparam linear_j = 6'd9;
  localparam linear_k = 6'd10;
  localparam linear_l = 6'd11;
  localparam linear_m = 6'd12;
  localparam linear_n = 6'd13;
  localparam linear_o = 6'd14;
  localparam linear_p = 6'd15;
  localparam linear_q = 6'd16;
  localparam linear_r = 6'd17;
  localparam linear_s = 6'd18;
  localparam linear_t = 6'd19;
  localparam linear_u = 6'd20;
  localparam linear_v = 6'd21;
  localparam linear_w = 6'd22;
  localparam linear_x = 6'd23;
  localparam linear_y = 6'd24;
  localparam linear_z = 6'd25;
  localparam linear_0 = 6'd26;
  localparam linear_1 = 6'd27;
  localparam linear_2 = 6'd28;
  localparam linear_3 = 6'd29;
  localparam linear_4 = 6'd30;
  localparam linear_5 = 6'd31;
  localparam linear_6 = 6'd32;
  localparam linear_7 = 6'd33;
  localparam linear_8 = 6'd34;
  localparam linear_9 = 6'd35;

  // PS2 scancodes
  localparam ps2_a = 8'h1C;
  localparam ps2_b = 8'h32;
  localparam ps2_c = 8'h21;
  localparam ps2_d = 8'h23;
  localparam ps2_e = 8'h24;
  localparam ps2_f = 8'h2B;
  localparam ps2_g = 8'h34;
  localparam ps2_h = 8'h33;
  localparam ps2_i = 8'h43;
  localparam ps2_j = 8'h3B;
  localparam ps2_k = 8'h42;
  localparam ps2_l = 8'h4B;
  localparam ps2_m = 8'h3A;
  localparam ps2_n = 8'h31;
  localparam ps2_o = 8'h44;
  localparam ps2_p = 8'h4D;
  localparam ps2_q = 8'h15;
  localparam ps2_r = 8'h2D;
  localparam ps2_s = 8'h1B;
  localparam ps2_t = 8'h2C;
  localparam ps2_u = 8'h3C;
  localparam ps2_v = 8'h2A;
  localparam ps2_w = 8'h1D;
  localparam ps2_x = 8'h22;
  localparam ps2_y = 8'h35;
  localparam ps2_z = 8'h1A;
  localparam ps2_0 = 8'h45;
  localparam ps2_1 = 8'h16;
  localparam ps2_2 = 8'h1E;
  localparam ps2_3 = 8'h26;
  localparam ps2_4 = 8'h25;
  localparam ps2_5 = 8'h2E;
  localparam ps2_6 = 8'h36;
  localparam ps2_7 = 8'h3D;
  localparam ps2_8 = 8'h3E;
  localparam ps2_9 = 8'h46;


  always_comb begin
    case (ps2_value)
      ps2_a: linear_value = linear_a;
      ps2_b: linear_value = linear_b;
      ps2_c: linear_value = linear_c;
      ps2_d: linear_value = linear_d;
      ps2_e: linear_value = linear_e;
      ps2_f: linear_value = linear_f;
      ps2_g: linear_value = linear_g;
      ps2_h: linear_value = linear_h;
      ps2_i: linear_value = linear_i;
      ps2_j: linear_value = linear_j;
      ps2_k: linear_value = linear_k;
      ps2_l: linear_value = linear_l;
      ps2_m: linear_value = linear_m;
      ps2_n: linear_value = linear_n;
      ps2_o: linear_value = linear_o;
      ps2_p: linear_value = linear_p;
      ps2_q: linear_value = linear_q;
      ps2_r: linear_value = linear_r;
      ps2_s: linear_value = linear_s;
      ps2_t: linear_value = linear_t;
      ps2_u: linear_value = linear_u;
      ps2_v: linear_value = linear_v;
      ps2_w: linear_value = linear_w;
      ps2_x: linear_value = linear_x;
      ps2_y: linear_value = linear_y;
      ps2_z: linear_value = linear_z;
      ps2_0: linear_value = linear_0;
      ps2_1: linear_value = linear_1;
      ps2_2: linear_value = linear_2;
      ps2_3: linear_value = linear_3;
      ps2_4: linear_value = linear_4;
      ps2_5: linear_value = linear_5;
      ps2_6: linear_value = linear_6;
      ps2_7: linear_value = linear_7;
      ps2_8: linear_value = linear_8;
      ps2_9: linear_value = linear_9;
      default: linear_value = linear_0;
    endcase
  end

  assign linear_valid = ps2_valid;

endmodule
