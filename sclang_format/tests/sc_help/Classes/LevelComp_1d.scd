// Source: Classes/LevelComp.schelp block 1 (part 4/7)
(
x = { |spread = 1, level = 0.1, center = 0|
    var n = 2;
	var snd = LFPulse.ar({ 100.exprand(2000) } ! n).range(-1, 1);
	var stereo = Splay.ar(snd, spread, level, center);
	Peak.ar(stereo, Impulse.kr(2)).ampdb.poll(2);
    stereo
}.play;
)
