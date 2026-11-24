// Source: Classes/SoundFileView.schelp block 0
(
w = Window.new("soundfile test", Rect(200, 300, 740, 100));
a = SoundFileView.new(w, Rect(20, 20, 700, 60));

f = SoundFile.new;
// ExampleFiles helps locate audio files used in examples
p = ExampleFiles.child;
// peek at the path to see location and the format of a path
p.postln;
f.openRead(p);
f.inspect;

a.soundfile = f;
a.read(0, f.numFrames);

a.timeCursorOn = true;
a.timeCursorColor = Color.red;
a.timeCursorPosition = 2050;
a.drawsWaveForm = true;
a.gridOn = true;
a.gridResolution = 0.2;

w.front;
)
