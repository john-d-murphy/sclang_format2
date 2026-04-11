// Source: Classes/Spring.schelp block 0 (part 3/3)
(
{ 	var m0, m1, m2, m3, m4, d, k, t;
	k = MouseX.kr(0.5, 100, 1);
	d = MouseY.kr(0.0001, 0.01, 1);
	t = Dust.ar(2);
	m0 = Spring.ar(ToggleFF.ar(t), 1 * k, 0.01);
	m1 = Spring.ar(m0, 0.5 * k, d);
	m2 = Spring.ar(m0, 0.6 * k, d);
	m3 = Spring.ar([m1,m2], 0.4 * k, d);
	m4 = Spring.ar(m3 - m1 + m2, 0.1 * k, d);
	CombL.ar(t, 0.1, LinLin.ar(m4, -10, 10, 1/8000, 1/100), 12)

}.play;
)
