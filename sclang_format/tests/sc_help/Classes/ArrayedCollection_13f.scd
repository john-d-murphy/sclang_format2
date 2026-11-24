// Source: Classes/ArrayedCollection.schelp block 13 (part 6/6)
(
var pitches =  [43.0, 55.0, 58.86, 57.42, 67.0];
fork {
	32.do{ |i|
		{
			var freq = pitches.foldAt(i).midicps;
			var env = Env.perc.ar(Done.freeSelf);
			SinOsc.ar(freq) * 0.1 * env
		}.play;
		0.2.wait
	}
}
)
