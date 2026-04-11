// Source: Classes/Spring.schelp block 0 (part 1/3)
(
{
	var inforce, outforce, freq, k, d;
	inforce = K2A.ar(MouseButton.kr(0,1,0)) > 0;
	k = MouseY.kr(0.1, 20, 1);
	d = MouseX.kr(0.00001, 0.1, 1);
	outforce = Spring.ar(inforce, k, d);
	freq = outforce * 400 + 500; // modulate frequency with the force
	SinOsc.ar(freq, 0, 0.2)
}.play;
)
