// Source: Classes/InFeedback.schelp block 0
(
SynthDef("help-InFeedback", { arg out=0, in=0;
	var input, sound;
		input = InFeedback.ar(in, 1);
		sound = SinOsc.ar(input * 1300 + 300, 0, 0.4);
		Out.ar(out, sound);

}).play;
)
