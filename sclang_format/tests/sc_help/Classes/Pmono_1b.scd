// Source: Classes/Pmono.schelp block 1 (part 2/4)
(
p = Pbind(
	\type, \set,	// This tells it we'll be setting parameters of an existing node...
	\id, x.nodeID,	// ...this tells it whose parameters we'll be setting
	\args, #[\freq, \amp], // and this tells it which parameters to set
	\freq, Pwhite(100, 1000),
	\dur, 0.2,
	\amp, Pseq((1, 0.99 .. 0.1), inf)
).play;
)
