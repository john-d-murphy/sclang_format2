// Source: Tutorials/Server_Tutorial.schelp block 28
(
var space, offset, timer, saw, envsaw, sampler, delay;

SynthDef("saw", { arg out=100, pan=0, trig=0.0, freq=500, amp=1, cutoff=10000, rezz=1;
	freq = Lag.kr(freq,0.1);
	Out.ar(out,Pan2.ar(RLPF.ar(Saw.ar([freq,freq*2],amp),cutoff,rezz),
		pan));
}).add;

SynthDef("envsaw",{ arg out=100, pan=0, sustain=0.5, freq=500, amp=1, cutoff=10000, rezz=1;
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.none, gate:amp);
	Out.ar(out,Pan2.ar(RLPF.ar(Saw.ar(Lag.kr(freq,0.1),env),cutoff,rezz)*amp,
		pan));
}).add;

SynthDef("delay", { arg out=0, delay = 0.4, decay = 14;
	var in;
	in = In.ar(out,2);
	Out.ar(out, CombN.ar(in, 0.5, delay, decay, 1, in));
}).add;

SynthDef("sampler",{ arg sample, trig=1,rate=1.0,out=0,bufnum=0,pan=0,amp=1, sustain=0.25;
	var env;
	env = EnvGen.kr(Env.perc(0.001, sustain, 0.001), doneAction: Done.freeSelf);
	Out.ar(out,
		Pan2.ar(
		PlayBuf.ar(1,bufnum,rate,InTrig.kr(trig),0,0)*amp,
			pan);
	)
}).add;

Tempo.bpm = 120;
timer = BeatSched.new;
offset = Tempo.tempo.reciprocal;

space = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

saw = Synth("saw");
delay = Synth.after(saw,"delay", [\decay, 20]);

timer.sched(0,{
	var r;
	r = Routine({ var wait, freq, cutoff,rezz;
		wait = Pseq([2],inf).asStream;
		freq = Pseq([30,40,42,40],inf).asStream;
		cutoff = Pfunc({500.rand2+1000}).asStream;
		rezz = 0.5;
		inf.do({
			saw.set("freq", freq.next.midicps, "cutoff", cutoff.next, "rezz", rezz, "amp", 0.1, "out", 0);
			(wait.next*offset).wait
		});
	});
	timer.sched(0, r);
});

timer.sched(0,{
	var r;
	r=Routine({ var wait, rate;
		wait = Pseq([0.25],inf).asStream;
		rate = Pfunc({0.5.rand}).asStream;
		inf.do({
			Synth.before(delay, "sampler", [\bufnum, space, \trig, 1, \amp,0.1, \rate, rate.next, \sustain, 		wait.next]);
			(wait.next*offset).wait});});
		timer.sched(0,r);
});

)
