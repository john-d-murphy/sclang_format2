// Source: Tutorials/Streams-Patterns-Events4.schelp block 10
(
var a, b, c, n;

n = 40;
a = { arg freq, amp, pan;
	Pan2.ar(SinOsc.ar(freq), pan, amp);
};
b = { arg amp, pan, freq;
	Pan2.ar(RLPF.ar(Saw.ar(freq), freq * 6, 0.1), pan, amp);
};
c = { arg pan, freq, amp;
	Pan2.ar(Resonz.ar(GrayNoise.ar, freq * 2, 0.1), pan, amp * 2);
};

Task({
	n.do({ arg i;
		SynthDef("Help-SPE4-EnvirDef-" ++ i.asString, { |out|
			var sound;
			Environment.use({
					// set values in the environment
				~freq = exprand(80, 600);
				~amp = 0.1 + 0.3.rand;
				~pan = 1.0.rand2;

					// call a randomly chosen instrument function
					// with values from the environment
				sound = [a,b,c].choose.valueEnvir;
			});
			sound = CombC.ar(sound, 0.2, 0.2, 3, 1, out);
			sound = sound * EnvGen.kr(
				Env.sine, doneAction: Done.freeSelf, timeScale: 1.0 + 6.0.rand, levelScale: 0.3
			);
			Out.ar(out, sound);
		}).send(s);
		0.02.wait;
	});
	loop({
		Synth( "Help-SPE4-EnvirDef-" ++ n.rand.asString );
		(0.5 + 2.0.rand).wait;
	});
}).play;
)
