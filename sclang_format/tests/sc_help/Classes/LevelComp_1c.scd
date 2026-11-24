// Source: Classes/LevelComp.schelp block 1 (part 3/7)
(
{ var n = 2, level = 0.1, spread = 1, pan = 0;
	LFPulse.ar({ 100.exprand(2000) } ! n).range(-1, 1) * level
}.play;
)
