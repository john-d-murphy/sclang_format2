// Source: Classes/Node.schelp block 12
{ PinkNoise.ar(1) * Line.kr(1, 0, 2, doneAction: Done.freeSelf) }.play.onFree { "done".postln };
