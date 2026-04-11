// Source: Classes/Splay.schelp block 0 (part 8/9)
(
x = { arg spread=1, level=0.2, center=0.0;
 Splay.arFill(10,
  { |i| SinOsc.ar( LFNoise2.kr( rrand(10, 20), 200, i + 3 * 100))  },
  spread,
  level,
  center
 );
}.play;
)
