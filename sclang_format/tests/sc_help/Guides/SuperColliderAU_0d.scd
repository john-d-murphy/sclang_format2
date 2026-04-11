// Source: Guides/SuperColliderAU.schelp block 0 (part 4/4)
z = { SoundIn.ar([0,1]) * SinOsc.ar(MouseX.kr(100, 1000)) }.play(u);
