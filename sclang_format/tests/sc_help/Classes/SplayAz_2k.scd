// Source: Classes/SplayAz.schelp block 2 (part 11/18)
(
x = { arg spread=1, level=0.5, width=2, center=0.0;
 SplayAz.arFill(
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
