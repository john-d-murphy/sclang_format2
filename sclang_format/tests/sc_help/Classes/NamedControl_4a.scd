// Source: Classes/NamedControl.schelp block 4 (part 1/11)
(
q = ();
q.makeEnv = { |q, env, doneAction = 0| EnvGen.kr(env, NamedControl.kr(\gate, 1), doneAction: doneAction) };
q.chooseNoise = { [ {PinkNoise.ar}, {WhiteNoise.ar}, {LFNoise2.ar(Rand(100, 1000))}].choose.value};
q.filterInput = { |q, in| [
	{ BPF.ar(in * 15, NamedControl.kr(\freq, 800), 0.2) },
	{ RHPF.ar(in, NamedControl.kr(\freq, 800, 0.2), 0.2) }
	].choose.value
};
)
