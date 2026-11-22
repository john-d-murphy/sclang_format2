// Source: Classes/AbstractFunction.schelp block 50 (part 2/2)
(
{ a = SinOsc.ar(335); b = SinOsc.ar(MouseX.kr(1, 1000, 1));
absdif(a, b) * 0.1 }.play;
)
