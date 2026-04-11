// Source: Classes/Tap.schelp block 0 (part 2/4)
(
SynthDef(\helpTap, { |out, bufnum|
	var source, capture;

	source= SoundIn.ar(0); // use headphones to avoid feedback
	capture= BufWr.ar(source, bufnum, Phasor.ar(0,1, 0, BufFrames.ir(bufnum),1));

	Out.ar(out, Tap.ar(bufnum, 1, [0.1,0.9])); // multichannel expansion, so one tap each ear
}).add;
)
