// Source: Classes/NoteOnResponder.schelp block 2 (part 1/2)
(
	c = NoteOnResponder({ |src,chan,note,vel|
		[src,chan,note,vel].postln;
		},
		nil, // any source
		nil, // any channel
		(50..60), // within this note range
		nil // any vel
	)
)
