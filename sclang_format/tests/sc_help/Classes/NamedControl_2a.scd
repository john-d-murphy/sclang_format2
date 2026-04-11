// Source: Classes/NamedControl.schelp block 2 (part 1/7)
a = { SinOsc.ar(\freq.kr(440, 1.0)) + Saw.ar(\freq.kr(440, 1.0) * 0.5) * 0.1 }.play;

a.set(\freq, 1220);
