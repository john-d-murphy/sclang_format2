// Source: Classes/QuartzComposerView.schelp block 1 (part 71/76)
(
o = OSCresponder(s.addr, '/tr', { |time, resp, msg|
	{ ~meters[msg[2]].level = (msg[3] + 0.01).explin(0.01, 1.01, 0, 1) }.defer;
}).add;
b = Buffer.read(s, ExampleFiles.child);
a = { var colum, noise, imp, delimp;
	imp = Impulse.kr(20);
	delimp = Delay1.kr(imp);
	colum = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
	noise = PinkNoise.ar(MouseX.kr);
	// measure Peak
	SendTrig.kr(imp, 0, Peak.ar(colum, delimp));
	SendTrig.kr(imp, 1, Peak.ar(noise, delimp));
	[colum, noise];
}.play;
)
