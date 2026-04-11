// Source: Classes/SplayZ.schelp block 0 (part 12/12)
(
x = { var src;
 src = SinOsc.ar( { |i| LFNoise2.kr( rrand(10, 20), 200, i * 100 + 400) } ! 10);
 SplayZ.ar(4, src, MouseY.kr(1, 0), 0.2, center: MouseX.kr(-1, 1));
}.scope;
)
