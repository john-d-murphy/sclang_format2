// Source: Classes/LFGauss.schelp block 4 (part 1/5)
(
var freq = 1000;
var ncycles = 10;
var width = 0.25;
var dur = ncycles / freq;
{
	var env = LFGauss.ar(dur, width, loop: 0, doneAction: Done.freeSelf).range;
	var son = FSinOsc.ar(freq, 0.5pi, env);
	son
}.plot(dur);
)
