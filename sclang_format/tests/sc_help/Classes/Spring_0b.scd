// Source: Classes/Spring.schelp block 0 (part 2/3)
(
{ 	var m0, m1, m2, m3, d, k, inforce;
	d = MouseY.kr(0.00001, 0.01, 1);
	k = MouseX.kr(0.1, 20, 1);
	inforce = K2A.ar(MouseButton.kr(0,1,0)) > 0;
	m0 = Spring.ar(inforce, k, 0.01);
	m1 = Spring.ar(m0, 0.5 * k, d);
	m2 = Spring.ar(m0, 0.6 * k + 0.2, d);
	m3 = Spring.ar(m1 - m2, 0.4, d);
	SinOsc.ar(m3 * 200 + 500, 0, 0.2) // modulate frequency with the force

}.play;
)
