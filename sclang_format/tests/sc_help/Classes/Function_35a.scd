// Source: Classes/Function.schelp block 35 (part 1/3)
{ SinOsc.ar + GrayNoise.ar(0.1) }.getToFloatArray(0.01, action: { arg array; a = array });
