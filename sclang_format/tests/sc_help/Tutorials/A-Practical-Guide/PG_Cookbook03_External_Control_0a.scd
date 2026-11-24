// Source: Tutorials/A-Practical-Guide/PG_Cookbook03_External_Control.schelp block 0 (part 1/4)
(
~legato = 1;
c = MIDIFunc.cc({ |value, num, chan, src|
	~legato = value.linlin(0, 127, 0.1, 2.5)
}, 1);	// 1 means modwheel
)
