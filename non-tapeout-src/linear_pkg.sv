package linear_pkg;
  typedef enum logic[5:0] {
      A = 6'd0,
      B = 6'd1, 
      C = 6'd2, 
      D = 6'd3,
      E = 6'd4,
      F = 6'd5, 
      G = 6'd6, 
      H = 6'd7,
      I = 6'd8, 
      J = 6'd9, 
      K = 6'd10, 
      L = 6'd11,
      M = 6'd12, 
      N = 6'd13, 
      O = 6'd14, 
      P = 6'd15,
      Q = 6'd16,
      R = 6'd17, 
      S = 6'd18, 
      T = 6'd19,
      U = 6'd20, 
      V = 6'd21, 
      W = 6'd22, 
      X = 6'd23,
      Y = 6'd24, 
      Z = 6'd25,
      zero = 6'd26,
      one = 6'd27, 
      two = 6'd28, 
      three = 6'd29,
      four = 6'd30, 
      five = 6'd31, 
      six = 6'd32, 
      seven = 6'd33,
      eight= 6'd34, 
      nine = 6'd35
  } scancode_t;

  function automatic logic[5:0] letter_to_linear_code(string letter);
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
    else if (letter == "0") return zero;
    else if (letter == "1") return one;
    else if (letter == "2") return two;
    else if (letter == "3") return three;
    else if (letter == "4") return four;
    else if (letter == "5") return five;
    else if (letter == "6") return six;
    else if (letter == "7") return seven;
    else if (letter == "8") return eight;
    else if (letter == "9") return nine;
    else return 6'd00;
  endfunction
endpackage
