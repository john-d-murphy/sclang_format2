// Source: Overviews/Operators.schelp block 20
{ // modulates and envelopes z
var z;
z = FSinOsc.ar(500);
z max: FSinOsc.ar(0.1);
}.play;
