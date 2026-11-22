// Source: Guides/Order-of-execution.schelp block 10 (part 2/9)
(
l = Bus.control(s, 1);  // get a bus for the LFO--not relevant to order-of-exec
b = Bus.audio(s, 2);	// assuming stereo--this is to keep the src->fx chain separate from
				// other similar chains
~synthgroup = Group.tail(s);
~fxgroup = Group.tail(s);

// now you have synthgroup --> fxgroup within the default group of s

// make some synthdefs to play with
SynthDef("order-of-ex-dist", { arg bus, preGain, postGain;
	var sig;
	sig = In.ar(bus, 2);
	sig = (sig * preGain).distort;
	ReplaceOut.ar(bus, sig * postGain);
}).add;

SynthDef("order-of-ex-pulse", { arg freq, bus, ffreq, pan, lfobus;
	var sig, noteLen;
	noteLen = In.kr(lfobus, 1);
	sig = RLPF.ar(Pulse.ar(freq, 0.2, 0.5), ffreq, 0.3);
	Out.ar(bus, Pan2.ar(sig, pan)
		* EnvGen.kr(Env.perc(0.1, 1), timeScale: noteLen, doneAction: Done.freeSelf));
}).add;

SynthDef("LFNoise1", { arg freq, mul, add, bus;
	Out.kr(bus, LFNoise1.kr(freq, mul:mul, add:add));
}).add;
)
