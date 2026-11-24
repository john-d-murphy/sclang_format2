// Source: Classes/Prout.schelp block 0 (part 3/4)
(
var a;
a = Prout({ loop { 1.yield; 2.yield; 7.yield; 10.do { 1.0.rand.yield } } }).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, val * 100 + 300]);
		0.02.wait;
	}
}.fork;
)
