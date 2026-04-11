// Source: Classes/Dswitch.schelp block 0 (part 2/2)
(
	{
		var d, trig;
		d = Dswitch1([
			Dwhite(3, 4, 2),
			Dwhite(0, 1, 2),
			Dseq([1, 1, 1, 0], 2)
		], Dseq([0, 1, 2, 1, 0], 2));

		trig = Impulse.kr(4);

		SinOsc.ar(
			Demand.kr(trig, 0, d).poll(trig)
			* 300 + 400
		)
		* 0.1 ! 2
	}.play;
);
