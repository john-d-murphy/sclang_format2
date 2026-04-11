// Source: Classes/Pbind.schelp block 2 (part 3/3)
(
Pbind(
	\instrument,		\test,
	\nharms,	     	Pseq([4, 10, 40], inf),
	\dur,			    Pseq([1, 1, 2, 1]/10, inf),
	#[freq, sustain],	Ptuple([ // assignment to multiple keys
					        Pseq( (1..16) * 50, 4),
				     	    Pseq([1/10, 0.5, 1, 2], inf)
				        ])
).play;
)
