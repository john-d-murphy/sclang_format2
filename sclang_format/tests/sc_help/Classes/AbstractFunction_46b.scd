// Source: Classes/AbstractFunction.schelp block 46 (part 2/2)
(
{ a = SinOsc.ar(335); b = SinOsc.ar(MouseX.kr(1, 1000, 1));
difsqr(a, b) * 0.1 }.play;
)
