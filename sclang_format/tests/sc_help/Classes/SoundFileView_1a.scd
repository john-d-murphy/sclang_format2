// Source: Classes/SoundFileView.schelp block 1 (part 1/68)
( // make a simple SoundFileView
y = Window.screenBounds.height - 120;
w = Window.new("soundfile test", Rect(200, y, 740, 100)).alwaysOnTop_(true);
w.front;
a = SoundFileView.new(w, Rect(20, 20, 700, 60));

f = SoundFile.new;
f.openRead(ExampleFiles.child);
// f.inspect;

a.soundfile = f;            // set soundfile
a.read(0, f.numFrames);     // read in the entire file.
a.refresh;                  // refresh to display the file.
)
