// Source: Tutorials/Getting-Started/04-Functions-and-Other-Functionality.schelp block 9
(
f = { arg a, b, c, d;
	(a + b) * c - d
};
f.value(2, c:3, b:4, d: 1); // (2 + 4) * 3 - 1
)
