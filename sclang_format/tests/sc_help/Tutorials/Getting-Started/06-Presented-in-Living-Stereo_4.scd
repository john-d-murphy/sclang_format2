// Source: Tutorials/Getting-Started/06-Presented-in-Living-Stereo.schelp block 4
(
{ var freq;
	freq = [[660, 880], [440, 660], 1320, 880].choose;
	SinOsc.ar(freq, 0, 0.2);
}.play;
)
