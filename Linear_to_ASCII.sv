module Linear_to_ASCII(
  input  logic [5:0] linear_value,
  input  logic       linear_valid,
  output logic [7:0] ascii_value,
  output logic       ascii_valid
);

  // ASCII values 
  localparam ascii_a = 8'd65;
  localparam ascii_b = 8'd66;
  localparam ascii_c = 8'd67;
  localparam ascii_d = 8'd68;
  localparam ascii_e = 8'd69;
  localparam ascii_f = 8'd70;
  localparam ascii_g = 8'd71;
  localparam ascii_h = 8'd72;
  localparam ascii_i = 8'd73;
  localparam ascii_j = 8'd74;
  localparam ascii_k = 8'd75;
  localparam ascii_l = 8'd76;
  localparam ascii_m = 8'd77;
  localparam ascii_n = 8'd78;
  localparam ascii_o = 8'd79;
  localparam ascii_p = 8'd80;
  localparam ascii_q = 8'd81;
  localparam ascii_r = 8'd82;
  localparam ascii_s = 8'd83;
  localparam ascii_t = 8'd84;
  localparam ascii_u = 8'd85;
  localparam ascii_v = 8'd86;
  localparam ascii_w = 8'd87;
  localparam ascii_x = 8'd88;
  localparam ascii_y = 8'd89;
  localparam ascii_z = 8'd90;
  localparam ascii_0 = 8'd48;
  localparam ascii_1 = 8'd49;
  localparam ascii_2 = 8'd50;
  localparam ascii_3 = 8'd51;
  localparam ascii_4 = 8'd52;
  localparam ascii_5 = 8'd53;
  localparam ascii_6 = 8'd54;
  localparam ascii_7 = 8'd55;
  localparam ascii_8 = 8'd56;
  localparam ascii_9 = 8'd57;
  localparam ascii_space = 8'd32;
  localparam ascii_backspace = 8'd8;
  localparam ascii_enter = 8'd13;
  
       
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
  localparam linear_space = 6'd36;
  localparam linear_backspace = 6'd37;
  localparam linear_enter = 6'd38;

  always_comb begin
    case (linear_value)
      linear_a: ascii_value = ascii_a;
      linear_b: ascii_value = ascii_b;
      linear_c: ascii_value = ascii_c;
      linear_d: ascii_value = ascii_d;
      linear_e: ascii_value = ascii_e;
      linear_f: ascii_value = ascii_f;
      linear_g: ascii_value = ascii_g;
      linear_h: ascii_value = ascii_h;
      linear_i: ascii_value = ascii_i;
      linear_j: ascii_value = ascii_j;
      linear_k: ascii_value = ascii_k;
      linear_l: ascii_value = ascii_l;
      linear_m: ascii_value = ascii_m;
      linear_n: ascii_value = ascii_n;
      linear_o: ascii_value = ascii_o;
      linear_p: ascii_value = ascii_p;
      linear_q: ascii_value = ascii_q;
      linear_r: ascii_value = ascii_r;
      linear_s: ascii_value = ascii_s;
      linear_t: ascii_value = ascii_t;
      linear_u: ascii_value = ascii_u;
      linear_v: ascii_value = ascii_v;
      linear_w: ascii_value = ascii_w;
      linear_x: ascii_value = ascii_x;
      linear_y: ascii_value = ascii_y;
      linear_z: ascii_value = ascii_z;
      linear_0: ascii_value = ascii_0;
      linear_1: ascii_value = ascii_1;
      linear_2: ascii_value = ascii_2;
      linear_3: ascii_value = ascii_3;
      linear_4: ascii_value = ascii_4;
      linear_5: ascii_value = ascii_5;
      linear_6: ascii_value = ascii_6;
      linear_7: ascii_value = ascii_7;
      linear_8: ascii_value = ascii_8;
      linear_9: ascii_value = ascii_9;
		linear_space: ascii_value = ascii_space;
		linear_backspace: ascii_value = ascii_backspace;
		linear_enter: ascii_value = ascii_enter;
      default:  ascii_value = ascii_2;
    endcase
  end

  assign ascii_valid = linear_valid;

endmodule