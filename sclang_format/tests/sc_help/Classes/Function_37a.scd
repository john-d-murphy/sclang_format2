// Source: Classes/Function.schelp block 37 (part 1/6)
{ SinOsc.ar + GrayNoise.ar(0.1) }.loadToFloatArray(0.01, action: { |array| a = array });
