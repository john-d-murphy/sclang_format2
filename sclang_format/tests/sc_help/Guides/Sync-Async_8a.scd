// Source: Guides/Sync-Async.schelp block 8 (part 1/3)
(
SynthDef("help-Buffer",{ arg out=0, bufnum;
	Out.ar(
		out,
		PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum))
	)
}).load(s);

y = Synth.basicNew("help-Buffer"); // not sent yet

b = Buffer.read(s, ExampleFiles.child, action: { arg buffer;
       // synth send its s_new msg to follow
       // after the buffer read completes
       s.sendBundle(nil, y.newMsg(s,[\bufnum,buffer],\addToTail));
   }
);
)
