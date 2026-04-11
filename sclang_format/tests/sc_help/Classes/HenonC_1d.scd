// Source: Classes/HenonC.schelp block 1 (part 4/4)
{ SinOsc.ar(HenonC.ar(40, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*800+900) * 0.04 ! 2 }.scope(s);
