// Source: Classes/Node.schelp block 13
(
fork {
    { SinOsc.ar(440 ! 2) * Line.kr(0, 1, 5, doneAction: Done.freeSelf) }.play.waitForFree;
    { PinkNoise.ar(1) * Line.kr(1, 0, 2, doneAction: Done.freeSelf) }.play.onFree {"done".postln};
}
)
