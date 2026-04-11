// Source: Classes/Function.schelp block 28 (part 1/3)
x = { |freq = 440| SinOsc.ar(freq, 0, 0.3) }.play; // this returns a Synth object;
x.set(\freq, 880);
