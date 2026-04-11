// Source: Classes/NoteOnResponder.schelp block 0 (part 1/2)
(
c = NoteOnResponder({ |src,chan,note,vel|
		[src,chan,note,vel].postln;
	});
	c.learn; // wait for the first note
)
