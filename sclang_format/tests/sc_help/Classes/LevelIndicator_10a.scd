// Source: Classes/LevelIndicator.schelp block 10 (part 1/7)
(
// something to meter
s.waitForBoot({
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

	x = {
		var colum, noise, imp, delimp, mul = 1;
	imp = Impulse.kr(10);
	delimp = Delay1.kr(imp);
	colum = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1) * mul;
	// measure rms and Peak
	SendReply.kr(imp, '/levels', [Amplitude.kr(colum), K2A.ar(Peak.ar(colum, delimp).lag(0, 3))]);
	colum;
}.play;

	a = LevelIndicator(bounds:Rect(100, 100, 100, 400)).front;
	a.onClose_({ x.free; o.free; });
o = OSCFunc({arg msg;
	{
		a.value = msg[3].ampdb.linlin(-40, 0, 0, 1);
		a.peakLevel = msg[4].ampdb.linlin(-40, 0, 0, 1);
	}.defer;
}, '/levels', s.addr);
})
)
