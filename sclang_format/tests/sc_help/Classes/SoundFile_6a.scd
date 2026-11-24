// Source: Classes/SoundFile.schelp block 6 (part 1/14)
(
f = SoundFile(PathName.tmp +/+ "sf-help.wav");
f.headerFormat = "WAV";
f.sampleFormat = "int16";
if(f.openWrite) {
	f.writeData(Signal.sineFill(1024, [1]));
	f.close;
} {
	"Failed to open %".format(f.path).warn;
};
)
