// Source: Classes/EnvGate.schelp block 0 (part 5/7)
(
a = {
	var sound1 = LPF.ar(Saw.ar(80), 600) * EnvGate.new;
	var sound2 = RLPF.ar(Saw.ar(200) * 0.5, 6000 * EnvGate.new + 60, 0.1) * EnvGate.new;
	sound1 + sound2
}.play;
)
