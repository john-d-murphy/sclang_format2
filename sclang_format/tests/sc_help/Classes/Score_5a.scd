// Source: Classes/Score.schelp block 5 (part 1/6)
(
SynthDef("helpscore", { |out, freq = 440|
    Out.ar(out,
        SinOsc.ar(freq, 0, 0.2) * Line.kr(1, 0, 0.5, doneAction: Done.freeSelf)
    )
}).store;
)
