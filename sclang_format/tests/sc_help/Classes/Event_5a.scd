// Source: Classes/Event.schelp block 5 (part 1/4)
SynthDef(\default, { |out| Out.ar(out, Line.kr(0.3, 0, 0.5) * SinOsc.ar(Rand(300, 500.0))) }).add;
