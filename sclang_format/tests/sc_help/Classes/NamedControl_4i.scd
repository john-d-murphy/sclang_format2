// Source: Classes/NamedControl.schelp block 4 (part 9/11)
(
a = {
	var channels = Array.fill(8, {
		q.filterInput(q.chooseNoise) * q.makeEnv(Env.asr, 2)
	});
	Splay.ar(channels);

}.play;
)
