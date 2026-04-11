// Source: Classes/NamedControl.schelp block 2 (part 3/7)
a = { SinOsc.ar(\freq.kr(440).lag(3.5)) + Saw.ar(\freq.kr(440).lag(0.05) * 0.5) * 0.1 }.play;

a.set(\freq, 1220);
