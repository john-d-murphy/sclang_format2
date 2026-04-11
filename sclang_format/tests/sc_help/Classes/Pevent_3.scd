// Source: Classes/Pevent.schelp block 3
(
SynthDef(\help_sinegrain,
	    { arg out=0, freq=440, sustain=0.05;
		        var env;
		        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
		        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;

a = Pn(
	Plazy({
		Pbind(
			\instrument, \help_sinegrain,
			\freq, Pgeom(rrand(200, 600), rrand(1.001, 1.01), rrand(10, 100)).wrap(100, 15000),
			\dur, Pgeom(rrand(0.2, 0.3), rrand(0.99, 0.92))
		)
	})
);


Tdef(\x, {
	var str = Pevent(a).asStream, event;
	loop {
		event = str.next;
		if(event[\freq] % 50 < 20) { event[\freq] = event[\freq] * [1, 1.2, 1.5] };
		event.play;
		event[\dur].wait;
	}

}).play;
)
