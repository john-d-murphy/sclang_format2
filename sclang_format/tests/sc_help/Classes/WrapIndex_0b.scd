// Source: Classes/WrapIndex.schelp block 0 (part 2/2)
(
t = [ 200, 300, 400, 500, 600, 800 ];
b = Buffer(s, t.size, 1);

// alloc and set the values
s.listSendMsg( b.allocMsg( b.setnMsg(0, t) ).postln );

SynthDef(\help_Index, { |out=0, bufnum=0|
	Out.ar(out,
		SinOsc.ar(
			WrapIndex.kr(
				bufnum,
				MouseX.kr(0, BufFrames.ir(bufnum) * 3)
			),
			0,
			0.5
		)
	)
}).play(s, [\bufnum, b.bufnum]);
)
