// Source: Classes/SoundFile.schelp block 5
(
f = SoundFile.new.headerFormat_("AIFF").sampleFormat_("int16").numChannels_(1);
f.openWrite("sounds/sfwrite.aiff");
	// sawtooth
b = Signal.sineFill(100, (1..20).reciprocal);
	// write multiple cycles (441 * 100 = 1 sec worth)
441.do({ f.writeData(b) });
f.close;
)
