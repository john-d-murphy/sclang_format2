// Source: Classes/SoundFile.schelp block 0
(
// ExampleFiles helps locate audio files used in examples
p = ExampleFiles.child;
// peek at the path to see location and the format of a path
p.postln;

f = SoundFile.new;
f.openRead(p);
f.inspect;
f.close;
)
