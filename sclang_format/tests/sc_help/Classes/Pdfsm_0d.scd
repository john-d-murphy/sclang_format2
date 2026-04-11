// Source: Classes/Pdfsm.schelp block 0 (part 4/5)
(
SynthDef(\help_Pdfsm2,
	{ |out, freq, gate=1|
		var n=8, env, osc;
		env = Linen.kr( gate, 0.01, 1, 0.03, 2 );
		osc = {
			Mix.fill( n, { |i|
				FSinOsc.ar(freq + Rand(-2.0,2.0), Rand(0, 0.05pi)) ring4:
				FSinOsc.ar(freq * (i+1));
			})
		}.dup * FSinOsc.kr(Rand(1.5,4.5),{Rand(-0.1pi,0.1pi)}.dup,0.6,env*0.4);
		Out.ar(out, env * osc / (n*4) )
}).add;
)
