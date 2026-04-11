// Source: Classes/MIDIOut.schelp block 11
(
var bpm, val, upper, lower;
bpm = 114.23;
val = (bpm*24).round.asInteger;
upper = val&2r11111110000000>>7;
lower = val&2r00000001111111;
[upper, lower].postln;
)
