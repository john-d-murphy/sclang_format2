// Source: Classes/LevelComp.schelp block 2 (part 1/4)
(
x = { |spread = 1, level = 0.1, center = 0|
	var n = 20;
	var snd = Splay.ar(LFPulse.ar({ 100.exprand(2000) } ! n).range(-1, 1),
		spread, level, center);
	Peak.ar(snd, 0.01, 1).ampdb.poll(1);
	snd
}.play;
)
