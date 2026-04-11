// Source: Overviews/Operators.schelp block 25
{ // distorts and envelopes z
var z;
z = FSinOsc.ar(500);
z min: FSinOsc.ar(0.1);
}.play;
