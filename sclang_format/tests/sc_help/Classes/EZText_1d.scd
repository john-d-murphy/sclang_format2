// Source: Classes/EZText.schelp block 1 (part 4/6)
(
Tdef(\text).set(\note, [0, 2, 7], \dur, { [0.1, 0.2].choose });

w = Window("EZTexts", Rect(200, 400, 304, 120)).front;
w.addFlowLayout;

TdefGui(Tdef(\text), 0, w);
Tdef(\text).envir.keysValuesDo { |k, v|
	EZText(w, Rect(0,0,300,40), k, { |ez|
		Tdef(\text).envir.put(*[k, ez.value].postcs);
	}, v);
};

Tdef(\text, { |ev|
	var mydur;
	loop {
		mydur = ev.dur;
		(note: ev.note, dur: mydur).postln.play;
		mydur.wait;
	}
}).play;
)
