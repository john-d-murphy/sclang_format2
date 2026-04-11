// Source: Guides/Multichannel-Expansion.schelp block 12
(
var freq, mod, modrange;

freq = Array.exprand(8, 400, 5000);
mod = Array.exprand(8, 0.1, 2);
modrange = Array.rand(8, 0.1, 40);

fork {
	[\freq, freq, \mod, mod, \modrange, modrange].flop.do { |args|
		args.postln;
		Synth("help_multichannel", args);
		0.3.wait;
	}
};
)
