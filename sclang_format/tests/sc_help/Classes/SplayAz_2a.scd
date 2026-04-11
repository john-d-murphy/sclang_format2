// Source: Classes/SplayAz.schelp block 2 (part 1/18)
(
x = { arg spread=1, level=0.2, width=2, center=0.0;
 SplayAz.ar(
  4,
  SinOsc.ar( { |i| LFNoise2.kr( rrand(10, 20), 200, i + 3 * 100) } ! 10),
  spread,
  level,
  width,
  center
 );
}.scope;
)
