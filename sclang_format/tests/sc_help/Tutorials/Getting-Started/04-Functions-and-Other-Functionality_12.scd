// Source: Tutorials/Getting-Started/04-Functions-and-Other-Functionality.schelp block 12
(
f = { arg a, b;
	var firstResult, finalResult;
	firstResult = a + b;
	finalResult = firstResult * 2;
	finalResult
};
f.value(2, 3);	// this will return (2 + 3) * 2 = 10
)
