// Source: Reference/softSet.schelp block 0 (part 15/15)
(
w = Window("softSet, softVol", Rect(500, 200, 400, 240)).front;
w.view.addFlowLayout;
NdefGui(Ndef(\test), 2, w);

	// can lose control if wiggled too fast
EZSlider(w, 340@30, \softSet, \freq, { |sl|
	Ndef(\test).softSet(\freq, sl.value, 0.05)
});

	// knows it was in control
EZSlider(w, 340@30, \knowsLast, \freq, Routine { |sl|
	var newVal, lastVal;
	loop {
		newVal = sl.value;
		Ndef(\test).softSet(\freq, newVal, 0.05, lastVal: lastVal);
		lastVal = newVal;
		\dummy.yield;
	}
});

	// same for volume - not too safe
EZSlider(w, 340@30, \softVol, \amp, { |sl|
	Ndef(\test).softVol_(sl.value, 0.05)
});
	// safer
EZSlider(w, 340@30, \knowLastV, \amp, Routine { |sl|
	var newVal, lastVal;
	loop {
		newVal = sl.value;
		Ndef(\test).softVol_(sl.value, 0.05, lastVal: lastVal);
		lastVal = newVal;
		\dummy.yield;
	}
});
)
