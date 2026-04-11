// Source: Tutorials/A-Practical-Guide/PG_Cookbook03_External_Control.schelp block 1 (part 1/4)
(
~legato = PatternProxy(1);
c = MIDIFunc.cc({ |value, num, chan, src|
	~legato.source = value.linlin(0, 127, 0.1, 2.5)
}, 1);
)
