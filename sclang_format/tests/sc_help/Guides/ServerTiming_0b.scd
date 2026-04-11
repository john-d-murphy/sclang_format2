// Source: Guides/ServerTiming.schelp block 0 (part 2/3)
SynthDef(\sinGrain, { |out = 0, freq = 440, amp = 0.5, dur = 1|
    Out.ar(out, SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.sine(1), timeScale:dur, doneAction: Done.freeSelf));
}).add;
