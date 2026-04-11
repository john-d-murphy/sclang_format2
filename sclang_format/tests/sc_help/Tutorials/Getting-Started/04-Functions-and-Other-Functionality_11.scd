// Source: Tutorials/Getting-Started/04-Functions-and-Other-Functionality.schelp block 11
(
f = { arg a, b;
	a + b
};
g = { |a, b|
	a + b
};
f.value(2, 2);
g.value(2, 2);
)
