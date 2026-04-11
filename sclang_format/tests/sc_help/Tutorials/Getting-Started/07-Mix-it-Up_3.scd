// Source: Tutorials/Getting-Started/07-Mix-it-Up.schelp block 3
(
	var n = 8;
	{
		Mix.fill(n, { arg index;
			var freq;
			index.postln;
			freq = 440 + index;
			freq.postln;
			SinOsc.ar(freq , 0, 1 / n)
		})
	}.play;
)
