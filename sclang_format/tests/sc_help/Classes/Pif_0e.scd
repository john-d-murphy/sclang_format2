// Source: Classes/Pif.schelp block 0 (part 5/5)
(
var a;
a = Pif(Pfunc({ 0.3.coin }), Pn(Pseries(0.5, 0.1, 10)), Pn(Pseries(6, -0.1, 10))).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, a.next * 600 + 300]);
		0.2.wait;
	}
}.fork;
)
