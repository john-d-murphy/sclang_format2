// Source: Guides/MIDI.schelp block 1 (part 1/2)
(
MIDIClient.init;
MIDIIn.connectAll;
m = MIDIFunc.noteOn({ |vel, num|
	"note % @ velocity %\n".postf(num, vel);
});
)
