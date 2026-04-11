// Source: Classes/TBall.schelp block 0 (part 1/5)
(
{
	var t, sf;
	sf = K2A.ar(MouseX.kr > 0.5) > 0;
	t = TBall.ar(sf, MouseY.kr(0.01, 1.0, 1), 0.01);
	Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), MouseX.kr(-1,1));
}.play;
)
