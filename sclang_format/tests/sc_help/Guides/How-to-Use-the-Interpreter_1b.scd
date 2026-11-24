// Source: Guides/How-to-Use-the-Interpreter.schelp block 1 (part 2/3)
r = Routine({
	200.do({|i|
		w.view.background = Color.blue(val: 1, alpha: 1 - (i * 0.005));
		0.005.wait;
	});
	w.close;
});
