// Source: Classes/Function.schelp block 38 (part 1/3)
{ SinOsc.ar + GrayNoise.ar(0.1) }.getToFloatArray(0.01, action: { |array| a = array });
