package lcd_pkg;
  typedef enum logic[7:0] {
      A = 8'h41,
      B = 8'h42, 
      C = 8'h43, 
      D = 8'h44,
      E = 8'h45,
      F = 8'h46, 
      G = 8'h47, 
      H = 8'h48,
      I = 8'h49, 
      J = 8'h4A, 
      K = 8'h4B, 
      L = 8'h4C,
      M = 8'h4D, 
      N = 8'h4E, 
      O = 8'h4F, 
      P = 8'h50,
      Q = 8'h51,
      R = 8'h52, 
      S = 8'h53, 
      T = 8'h54,
      U = 8'h55, 
      V = 8'h56, 
      W = 8'h57, 
      X = 8'h58,
      Y = 8'h59, 
      Z = 8'h5A
  } scancode_t;

  function automatic logic[7:0] letter_to_lcd_code(string letter);
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
    else return 8'h00;
  endfunction
endpackage
