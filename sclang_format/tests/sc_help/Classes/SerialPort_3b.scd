// Source: Classes/SerialPort.schelp block 3 (part 2/4)
(
r = Routine({
	inf.do{|i|
		p.put(i.fold(0, 100).linexp(0, 100, 1, 255).asInteger.postln);
		0.02.wait;
	};
}).play;
)
