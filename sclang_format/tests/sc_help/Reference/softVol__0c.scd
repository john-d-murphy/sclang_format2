// Source: Reference/softVol_.schelp block 0 (part 3/3)
(
w = Window("softVol", Rect(500, 200, 400, 240)).front;
w.view.addFlowLayout;
NdefGui(Ndef(\test), 2, w);

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
