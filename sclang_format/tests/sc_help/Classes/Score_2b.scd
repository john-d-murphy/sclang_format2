// Source: Classes/Score.schelp block 2 (part 2/3)
(
var f, g;
TempoClock.default.tempo = 1;
g = [
	[0.1, [\s_new, \helpscore, 1000, 0, 0, \freq, 440]],
	[0.2, [\s_new, \helpscore, 1001, 0, 0, \freq, 660]],
	[0.3, [\s_new, \helpscore, 1002, 0, 0, \freq, 220]],
	[1, [\c_set, 0, 0]] // finish
	];
f = File(Platform.defaultTempDir +/+ "score-test", "w");
f.write(g.asCompileString);
f.close;
)
