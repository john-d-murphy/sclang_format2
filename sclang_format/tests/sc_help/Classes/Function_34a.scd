// Source: Classes/Function.schelp block 34 (part 1/5)
{ SinOsc.ar + GrayNoise.ar(0.1) }.loadToFloatArray(0.01, action: { arg array; a = array });
