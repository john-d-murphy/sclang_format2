// Source: Classes/NoteOffResponder.schelp block 0 (part 1/2)
(
c = NoteOffResponder({ |src,chan,note,vel|
		[src,chan,note,vel].postln;
	});
	c.learn; // wait for the first note off
)
