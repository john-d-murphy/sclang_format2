// Source: Classes/Median.schelp block 0 (part 9/9)
(
// use LeakDC for low frequency noise
Synth.play({
	LeakDC.ar(Median.ar(31, WhiteNoise.ar(0.1) + SinOsc.ar(800,0,0.1)), 0.9)
});
)
