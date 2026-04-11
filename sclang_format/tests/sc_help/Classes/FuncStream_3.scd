// Source: Classes/FuncStream.schelp block 3
(
// create 16 different series
a = {
	var diff = [2, 4, 5].choose * [1, -1].choose;
	var val = 0;
	var stream = FuncStream({
		// next function
		val = val + diff;
		if(abs(val) > 30) { stream.reset };
		val
	}, {
		// reset function
		val = 0
	});
	stream
}.dup(16);

// play them as parallel notes
fork {
	loop {
		(
			note: a.collect { |f| f.next.postln },
			sustain: 0.1
		).play;

		// reset a randomly chosen FuncStream
		a.choose.reset;
		0.16.wait;
	}
}
)
