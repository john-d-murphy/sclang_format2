// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/12.schelp block 8 (part 2/2)
(
Synth.head(
	~source,
	"aLoopingSamplePlayer", [\outBus, 3, \bufNum, b, \rateScale, 1, \mul, 0.051]);
Synth.head(
	~effect,
	"ampMod", [\inBus, 3, \outBus, 5, \modFreq, 1000]);
Synth.tail(
	~effect,
	"aLowPassFilter", [\inBus, 5, \outBus, 0, \freq, 500, \freqDev, 200, \boost, 7])
)
