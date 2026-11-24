// Source: Classes/Gendy2.schelp block 1 (part 17/18)
(
{
	var n;
	n = 15;
	
	0.5 * Mix.fill(n, {
		var freq, numcps;
		
		freq = rrand(130, 160.3);
		numcps = rrand(2, 20);
		Pan2.ar(
			Gendy2.ar(
				6.rand, 6.rand, 10.0.rand, 10.0.rand, freq, freq*exprand(1.0, 2.0),
				10.0.rand, 10.0.rand, numcps, 
				SinOsc.kr(exprand(0.02, 0.2), 0, numcps/2, numcps/2),
				10.0.rand, 10.0.rand, 0.5/(n.sqrt)
			), 
			1.0.rand2
		)
	})
}.play
)
