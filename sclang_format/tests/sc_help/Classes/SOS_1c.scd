// Source: Classes/SOS.schelp block 1 (part 3/3)
(
{
	var rho, theta, b1, b2, vib;
	theta = MouseX.kr(0.2pi, pi);
	rho = MouseY.kr(0.6, 0.99);
	b1 = 2.0 * rho * cos(theta);
	b2 = rho.squared.neg;

	vib = SOS.kr(LFSaw.kr(3.16), 1.0, 0.0, 0.0, b1, b2);
	SinOsc.ar( vib * 200 + 600) * 0.2
}.play
)
