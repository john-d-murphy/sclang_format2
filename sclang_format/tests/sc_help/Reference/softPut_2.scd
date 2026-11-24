// Source: Reference/softPut.schelp block 2
(
w = Window("softSet, softVol", Rect(500, 200, 400, 240)).front;
w.view.addFlowLayout;
PdefGui(Pdef(\test), 2, w, 340@80);

	// can lose control if wiggled too fast
EZSlider(w, 340@30, \softSetDur, [0.03, 3, \exp], { |sl|
	Pdef(\test).softSet(\dur, sl.value, 0.05)
});

	// knows it was in control
EZSlider(w, 340@30, \knowsLast, [0.03, 3, \exp], Routine { |sl|
	var newVal, lastVal;
	loop {
		newVal = sl.value;
		Pdef(\test).softSet(\dur, newVal, 0.05, lastVal: lastVal);
		lastVal = newVal;
		\dummy.yield;
	}
});
)
