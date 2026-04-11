// Source: Classes/Splay.schelp block 0 (part 9/9)
(
x = { var src;
 src = SinOsc.ar( { |i| LFNoise2.kr( rrand(10, 20), 200, i + 3 * 100) } ! 10);
 Splay.ar(src, MouseY.kr(1, 0), 0.2, MouseX.kr(-1, 1));
}.play;
)
