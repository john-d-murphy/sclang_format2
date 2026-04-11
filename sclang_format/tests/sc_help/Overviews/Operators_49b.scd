// Source: Overviews/Operators.schelp block 49 (part 2/2)
(
{
var mul = 0.2 moddif: FSinOsc.ar(2, 0, 0.5);
FSinOsc.ar(440, 0, mul);
}.play;
)
