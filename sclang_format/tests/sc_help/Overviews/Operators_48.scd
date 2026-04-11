// Source: Overviews/Operators.schelp block 48
(
{ // creates a rhythm
var mul = 0.2 absdif: FSinOsc.ar(2, 0, 0.5);
FSinOsc.ar(440, 0, mul);
}.play;
)
