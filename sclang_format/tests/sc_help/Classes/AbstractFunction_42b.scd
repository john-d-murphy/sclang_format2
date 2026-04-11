// Source: Classes/AbstractFunction.schelp block 42 (part 2/2)
(
{ a = SinOsc.ar(335); b = SinOsc.ar(MouseX.kr(1, 1000, 1));
ring1(a, b) * 0.1 }.play;
)
