// Source: Classes/Prorate.schelp block 0 (part 5/5)
(
var a, x;
a = Prorate(
	Prand([2/3, 1/3, [0.3, 0.3, 0.4], [0.6, 0.4]], inf),
	Pseq([1, 2, 1, 3, 12], inf)
);

3.do {
	{
	var x = a.asStream;
	var freq = rrand(72, 84).midicps;
		loop {
			Synth(\help_sinegrain, [\freq, freq]);
			(0.25 * x.next).wait;
		}
	}.fork;
};
)
