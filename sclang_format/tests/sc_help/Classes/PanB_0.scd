// Source: Classes/PanB.schelp block 0
play({
	#w, x, y, z = PanB.ar(WhiteNoise.ar, LFSaw.kr(0.5,pi), FSinOsc.kr(0.31, 0.5pi), 0.3);
	//decode for 4 channels
	DecodeB2.ar(4, w, x, y, 0.5);
});
