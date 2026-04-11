// Source: Classes/LorenzL.schelp block 2
{ SinOsc.ar(Lag.ar(LorenzL.ar(MouseX.kr(1, 200)),3e-3)*800+900)*0.4 }.play(s);
