// Source: Classes/Score.schelp block 3
(
var f, o;
g = [
	[0.1, [\s_new, \helpscore, 1000, 0, 0, \freq, 440]],
	[0.2, [\s_new, \helpscore, 1001, 0, 0, \freq, 660],
		[\s_new, \helpscore, 1002, 0, 0, \freq, 880]],
	[0.3, [\s_new, \helpscore, 1003, 0, 0, \freq, 220]],
	[1, [\c_set, 0, 0]] // finish
	];
o = ServerOptions.new.numOutputBusChannels = 1; // mono output
Score.recordNRT(g, Platform.defaultTempDir +/+ "help-oscFile", Platform.defaultTempDir +/+ "helpNRT.aiff", options: o); // synthesize
)
