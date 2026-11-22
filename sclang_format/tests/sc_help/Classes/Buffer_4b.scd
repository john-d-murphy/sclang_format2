// Source: Classes/Buffer.schelp block 4 (part 2/7)
(
SynthDef(\help_Buffer, { |out = 0, bufnum|
	Out.ar(out,
		PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
	)
}).add;

y = Synth.basicNew(\help_Buffer); // not sent yet
b = Buffer.readNoUpdate(s, ExampleFiles.child,
	completionMessage: { |buffer|
		// synth add its s_new msg to follow
		// after the buffer read completes
		y.newMsg(s, [\bufnum, buffer], \addToTail)
	});
)
