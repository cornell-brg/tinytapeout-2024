package ascii_pkg;
  typedef enum logic[7:0] {
    a = 8'd65,
    b = 8'd66,
    c = 8'd67,
    d = 8'd68,
    e = 8'd69,
    f = 8'd70,
    g = 8'd71,
    h = 8'd72,
    i = 8'd73,
    j = 8'd74,
    k = 8'd75,
    l = 8'd76,
    m = 8'd77,
    n = 8'd78,
    o = 8'd79,
    p = 8'd80,
    q = 8'd81,
    r = 8'd82,
    s = 8'd83,
    t = 8'd84,
    u = 8'd85,
    v = 8'd86,
    w = 8'd87,
    x = 8'd88,
    y = 8'd89,
    z = 8'd90,
    n0 = 8'd48,
    n1 = 8'd49,
    n2 = 8'd50,
    n3 = 8'd51,
    n4 = 8'd52,
    n5 = 8'd53,
    n6 = 8'd54,
    n7 = 8'd55,
    n8 = 8'd56,
    n9 = 8'd57,
    space = 8'd32,
    backspace = 8'd8,
    enter = 8'd13
  } scancode_t;
  
  function automatic logic[7:0] letter_to_ascii_code(string letter);
    if (letter == "a") return a;
    else if (letter == "b") return b;
    else if (letter == "c") return c;
    else if (letter == "d") return d;
    else if (letter == "e") return e;
    else if (letter == "f") return f;
    else if (letter == "g") return g;
    else if (letter == "h") return h;
    else if (letter == "i") return i;
    else if (letter == "j") return j;
    else if (letter == "k") return k;
    else if (letter == "l") return l;
    else if (letter == "m") return m;
    else if (letter == "n") return n;
    else if (letter == "o") return o;
    else if (letter == "p") return p;
    else if (letter == "q") return q;
    else if (letter == "r") return r;
    else if (letter == "s") return s;
    else if (letter == "t") return t;
    else if (letter == "u") return u;
    else if (letter == "v") return v;
    else if (letter == "w") return w;
    else if (letter == "x") return x;
    else if (letter == "y") return y;
    else if (letter == "z") return z;
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
    else return 8'd00;
  endfunction
endpackage