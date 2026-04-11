// Source: Classes/Plotter.schelp block 15 (part 1/2)
(
a = { (0..10).scramble.normalize }.dup(2).plot;
a.editMode = true;
a.editFunc = { |...args| args.postln };
)
