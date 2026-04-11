// Source: Classes/OffsetOut.schelp block 0 (part 4/4)
SynthDef("trig1",{
	var gate,tone;
	gate = Trig1.ar(1.0,t);
	tone = In.ar(10,1); // tone comes in normally
	// but is then delayed when by the OffsetOut
	OffsetOut.ar(0,
		tone * EnvGen.ar(
				Env([0,0.1,0.1,0],[0.01,1.0,0.01],[-4,4],2),
				gate,doneAction: Done.freeSelf
			)
	)
})
