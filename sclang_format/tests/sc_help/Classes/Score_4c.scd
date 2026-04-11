// Source: Classes/Score.schelp block 4 (part 3/8)
(
var f, g;
TempoClock.default.tempo = 1;
g = [
	[0.1, [\s_new, \helpscore, 1000, 0, 0, \freq, 440]],
	[0.2, [\s_new, \helpscore, 1001, 0, 0, \freq, 660],
		[\s_new, \helpscore, 1002, 0, 0, \freq, 880]],
	[0.3, [\s_new, \helpscore, 1003, 0, 0, \freq, 220]],
	[1, [\c_set, 0, 0]] // finish
	];
f = File(Platform.defaultTempDir +/+ "score-test","w");
f.write(g.asCompileString);
f.close;
)
