// Source: Classes/Done.schelp block 0 (part 1/2)
(
SynthDef("Done-help", { arg out, t_trig;
	var line, a, b;

	line= Line.kr(1,0,1);

	a= SinOsc.ar(440,0,0.1*line); //sound fading out
	b= WhiteNoise.ar(Done.kr(line)*0.1); //noise starts at end of line

	Out.ar(out, Pan2.ar(a+b));
}).add;
)
