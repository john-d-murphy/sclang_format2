// Source: Classes/Plotter.schelp block 15 (part 2/2)
(
a = { (0..10).scramble.normalize(300, 400) }.dup.plot;
a.specs = \freq; a.plotMode = \bars;
a.editMode = true;
x = {
	var phase = SinOsc.ar(\rate.kr(a.value[1]));
	SinOsc.ar(\freq.kr(a.value[0]), phase).mean * 0.1
}.play;
a.editFunc = { |plotter, plotIndex, i, val|
	x.setn(\freq, a.value[0]);
	x.setn(\rate, a.value[1]);
};
a.parent.onClose = { x.release };
)
