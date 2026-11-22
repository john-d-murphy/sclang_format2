// Source: Tutorials/Getting-Started/04-Functions-and-Other-Functionality.schelp block 8
(
f = { arg a, b;
    a / b               // '/' means divide
};
f.value(10, 2);         // regular style
f.value(b: 2, a: 10);   // keyword style
)
