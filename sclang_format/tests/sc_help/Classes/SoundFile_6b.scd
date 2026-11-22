// Source: Classes/SoundFile.schelp block 6 (part 2/14)
(
var p = PathName.tmp +/+ "sf-help.wav";
f = SoundFile.openWrite(p, "WAV", "int16");
if(f.notNil) {
	f.writeData(Signal.sineFill(1024, [1]));
	f.close;
} {
	"Failed to open %".format(p).warn;
};
)
