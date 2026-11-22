// Source: Other/JITLibChanges3.7.schelp block 3 (part 187/248)
(
SynthDef(\echo, { arg out=0, maxdtime=0.2, dtime=0.2, decay=2, gate=1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(out, 2);
    XOut.ar(out, env, CombL.ar(in * env, maxdtime, dtime, decay, 1, in));
}, [\ir, \ir, 0.1, 0.1, 0]).add;

SynthDef(\distort, { arg out=0, pregain=40, amp=0.2, gate=1;
    var env;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	XOut.ar(out, env, (In.ar(out, 2) * pregain).distort + Dust2.ar([4, 10, 100], [0.4, 0.01, 0.01]).sum * amp);
}, [\ir, 0.1, 0.1, 0]).add;

SynthDef(\wah, { arg out=0, gate=1, rate = 0.3, max = 8000, rq = 0.1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.4, 2);
    in = In.ar(out, 2);
    XOut.ar(out, env, RLPF.ar(in, LinExp.kr(LFNoise1.kr(rate), -1, 1, 200, max), rq).softclip * 0.8);
}, [\ir, 0]).add;
)
