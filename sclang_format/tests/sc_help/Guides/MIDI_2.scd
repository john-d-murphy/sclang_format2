// Source: Guides/MIDI.schelp block 2
(
MIDIClient.init;
m = MIDIOut(0, MIDIClient.destinations.at(0).uid);
m.noteOn(0, 60, 60);
)
