// Source: Classes/IndexL.schelp block 0 (part 3/6)
(
// indexing into a changeable table
t = [ 200, 300, 400, 500, 600, 800 ];
b = Buffer(s, t.size, 1);

// alloc and set the values
s.listSendMsg( b.allocMsg( b.setnMsg(0, t) ).postln );

SynthDef(\help_index, { |out = 0, bufnum = 0|
	Out.ar(out,
		SinOsc.ar(
			IndexL.kr(
				bufnum,
				LFSaw.kr(2).range(0, BufFrames.kr(bufnum))
			),
			0,
			0.5
		)
	)
}).play(s, [\bufnum, b]);
)
