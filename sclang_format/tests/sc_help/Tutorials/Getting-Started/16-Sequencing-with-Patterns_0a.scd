// Source: Tutorials/Getting-Started/16-Sequencing-with-Patterns.schelp block 0 (part 1/3)
(
r = Routine({
	[60, 72, 71, 67, 69, 71, 72, 60, 69, 67].do({ |midi| midi.yield });
});
)
