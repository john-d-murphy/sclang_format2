// Source: Classes/Splay.schelp block 0 (part 1/9)
(
x = { arg spread=1, level=0.2, center=0.0;
 Splay.ar(
  SinOsc.ar( { |i| LFNoise2.kr(1).exprange(200, 4000) } ! 10),
  spread,
  level,
  center
 );
}.play;
)
