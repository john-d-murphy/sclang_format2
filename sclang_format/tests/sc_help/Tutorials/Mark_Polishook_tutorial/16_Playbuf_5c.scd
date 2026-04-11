// Source: Tutorials/Mark_Polishook_tutorial/16_Playbuf.schelp block 5 (part 3/4)
(
// add the samplePlayer to the source group
~theSource = Synth.head(
	~source,
	"aLoopingSamplePlayer", [\outBus, 3, \bufNum, b, \rateScale, 1, \mul, 0.051]);
// add an amplitude modulation synth to the head of the effects group
~fx1 = Synth.head(
	~effect,
	"ampMod", [\inBus, 3, \outBus, 5, \modFreq, 1]);
// add filtering to the tail of the effects group
~fx2 = Synth.tail(
	~effect,
	"aLowPassFilter", [\inBus, 5, \outBus, 0, \boost, 5])
)
