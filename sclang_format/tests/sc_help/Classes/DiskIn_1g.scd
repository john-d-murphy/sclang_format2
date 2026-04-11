// Source: Classes/DiskIn.schelp block 1 (part 7/13)
(
p = Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff";
a = SoundFile.new;
a.openRead(p);
d = a.numFrames/s.sampleRate; // get the duration
a.close; // don't forget
b = Buffer.cueSoundFile(s, p, 0, 1);
f = { DiskIn.ar(1, b.bufnum) };
x = f.play;
r = Routine({
	loop({ d.wait; x.free; x = f.play; b.close( b.cueSoundFileMsg(p, 0)) });
}).play; )
