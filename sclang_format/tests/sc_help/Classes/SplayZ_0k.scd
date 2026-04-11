// Source: Classes/SplayZ.schelp block 0 (part 11/12)
(
x = { arg spread=1, level=0.5, width=2, center=0.0;
 SplayZ.arFill(
  4,
  10,
  { |i| SinOsc.ar( LFNoise2.kr( rrand(10, 20), 200, i + 3 * 100) ) },
  spread,
  level,
  width,
  center
 );
}.scope;
)
