// Source: Classes/Gendy3.schelp block 0 (part 16/17)
(
{
	var n = 15;
	
	0.5 * Mix.fill(n, {
		var freq, numcps;
		
		freq = rrand(130, 160.3);
		numcps = rrand(2, 20);
		Pan2.ar(
			Gendy3.ar(6.rand, 6.rand, 10.0.rand, 10.0.rand, freq*exprand(1.0, 2.0), 10.0.rand, 10.0.rand, numcps, SinOsc.kr(exprand(0.02, 0.2), 0, numcps/2, numcps/2), 0.5/(n.sqrt)), 
			1.0.rand2
		)
	});
}.play
)
