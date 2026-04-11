// Source: Classes/Synth.schelp block 6 (part 1/4)
(
s.waitForBoot({
    SynthDef(\helpSeti, { |out, freqs = #[100,150,200,250]|
        Out.ar(out, SinOsc.ar(freqs.poll,0,0.1).sum ! 2)
    }).add;
    s.sync;
    x = Synth(\helpSeti);
})
)
