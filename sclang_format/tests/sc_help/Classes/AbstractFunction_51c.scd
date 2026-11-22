// Source: Classes/AbstractFunction.schelp block 51 (part 3/3)
(
{ a = SinOsc.ar(335); b = SinOsc.ar(MouseX.kr(1, 1000, 1));
rrand(a, b) * 0.1 }.play;
)
