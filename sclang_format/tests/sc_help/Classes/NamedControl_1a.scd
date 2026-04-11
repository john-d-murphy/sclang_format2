// Source: Classes/NamedControl.schelp block 1 (part 1/4)
a = { SinOsc.ar(NamedControl.kr(\freq, [300, 330, 370], [1, 0.3, 0.02])).sum * 0.1 }.play;
