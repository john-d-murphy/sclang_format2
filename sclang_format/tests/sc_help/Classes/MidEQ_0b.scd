// Source: Classes/MidEQ.schelp block 0 (part 2/10)
(
{ var in;
  in = PinkNoise.ar(0.2) + SinOsc.ar(600, 0, 0.1);
  MidEQ.ar(in, SinOsc.kr(0.2, 0.5pi) * 2 + 600, 0.01, -24)
}.play
)
