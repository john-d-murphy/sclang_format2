// Source: Classes/MIDIResponder.schelp block 0
NoteOnResponder({ |src, chan, num, vel| [src, chan, num, vel].postln },
	nil,	// any port
	[2, 7],	// midi channels 2 or 7 only
	(0, 2..126),	// this is an array of even numbers. could also be specified as { |num| num.even } or _.even
	{ |vel| vel > 50 });
