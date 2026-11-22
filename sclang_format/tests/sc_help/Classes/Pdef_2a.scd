// Source: Classes/Pdef.schelp block 2 (part 1/10)
(
SynthDef(\Pdefhelp, { |out, freq, sustain = 1, amp = 1, pan|
    var env = EnvGen.kr(Env.perc(0.01, sustain), 1, doneAction: Done.freeSelf);
    Out.ar(out, Pan2.ar(SinOsc.ar(freq, 0.5pi, amp * env), pan));
}).add;
)
