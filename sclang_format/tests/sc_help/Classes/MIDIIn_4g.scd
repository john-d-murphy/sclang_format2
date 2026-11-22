// Source: Classes/MIDIIn.schelp block 4 (part 7/12)
(
~noteOn = { |src, chan, num, vel|
	b.value = num.midicps.postln;
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);

~control = { |src, chan, num, val|
	[chan, num, val].postln;
};
MIDIIn.addFuncTo(\control, ~control);

~bend = { |src, chan, val|
	val.postln;
};
MIDIIn.addFuncTo(\bend, ~bend);
)
