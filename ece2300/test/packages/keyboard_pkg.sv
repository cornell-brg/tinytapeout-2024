package keyboard_pkg;
  typedef enum logic[7:0] {
      A = 8'h1C,
      B = 8'h32, 
      C = 8'h21, 
      D = 8'h23,
      E = 8'h24,
      F = 8'h2B, 
      G = 8'h34, 
      H = 8'h33,
      I = 8'h43, 
      J = 8'h3B, 
      K = 8'h42, 
      L = 8'h4B,
      M = 8'h3A, 
      N = 8'h31, 
      O = 8'h44, 
      P = 8'h4D,
      Q = 8'h15,
      R = 8'h2D, 
      S = 8'h1B, 
      T = 8'h2C,
      U = 8'h3C, 
      V = 8'h2A, 
      W = 8'h1D, 
      X = 8'h22,
      Y = 8'h35, 
      Z = 8'h1A,
      n0 = 8'h45,
      n1 = 8'h16,
      n2 = 8'h1E,
      n3 = 8'h26,
      n4 = 8'h25,
      n5 = 8'h2E,
      n6 = 8'h36,
      n7 = 8'h3D,
      n8 = 8'h3E,
      n9 = 8'h46,
      space = 8'h29,
      backspace = 8'h66,
      enter = 8'h5A
  } scancode_t;

  function automatic logic[7:0] letter_to_scancode(string letter);
    if (letter == "a") return A;
    else if (letter == "b") return B;
    else if (letter == "c") return C;
    else if (letter == "d") return D;
    else if (letter == "e") return E;
    else if (letter == "f") return F;
    else if (letter == "g") return G;
    else if (letter == "h") return H;
    else if (letter == "i") return I;
    else if (letter == "j") return J;
    else if (letter == "k") return K;
    else if (letter == "l") return L;
    else if (letter == "m") return M;
    else if (letter == "n") return N;
    else if (letter == "o") return O;
    else if (letter == "p") return P;
    else if (letter == "q") return Q;
    else if (letter == "r") return R;
    else if (letter == "s") return S;
    else if (letter == "t") return T;
    else if (letter == "u") return U;
    else if (letter == "v") return V;
    else if (letter == "w") return W;
    else if (letter == "x") return X;
    else if (letter == "y") return Y;
    else if (letter == "z") return Z;
    else if (letter == "0") return n0;
    else if (letter == "1") return n1;
    else if (letter == "2") return n2;
    else if (letter == "3") return n3;
    else if (letter == "4") return n4;
    else if (letter == "5") return n5;
    else if (letter == "6") return n6;
    else if (letter == "7") return n7;
    else if (letter == "8") return n8;
    else if (letter == "9") return n9;
    else if (letter == "space") return space;
    else if (letter == "backspace") return backspace;
    else if (letter == "enter") return enter;
    else return 8'h00;
  endfunction
endpackage
