// Source: Classes/Env.schelp block 31 (part 7/7)
(
{
	var factors = (0, 0.1..1);
	factors.do {|f| Synth(\help_EnvBlend, [\factor, f.postln]); 1.wait };
}.fork
);
