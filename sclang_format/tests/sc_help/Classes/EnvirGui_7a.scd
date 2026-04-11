// Source: Classes/EnvirGui.schelp block 7 (part 1/5)
(
Tdef(\text).set(\note, [0, 2, 7], \dur, { [0.1, 0.2, 0.4].choose }, \pan, 0, \amp, 0.1);

w = Window("EZTexts", Rect(200, 400, 304, 120)).front;
w.addFlowLayout;

TdefGui(Tdef(\text), 0, parent: w);

e = EnvirGui(Tdef(\text).envir, 4, parent: w);

Tdef(\text, { |ev|
	var mydur;
	loop {
		mydur = ev.dur;
		(note: ev.note, dur: mydur, amp: ev.amp, pan: ev.pan).postln.play;
		mydur.wait;
	}
}).play;
)
