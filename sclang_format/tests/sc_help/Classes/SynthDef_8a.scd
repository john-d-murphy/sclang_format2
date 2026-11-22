// Source: Classes/SynthDef.schelp block 8 (part 1/9)
(
// the basic wrapper
~makeEffect = { |name, func, lags, numChannels = 2|

	SynthDef(name, { |i_bus = 0, gate = 1, wet = 1|
		var in, sound, env, lfo;
		in = In.ar(i_bus, numChannels);
		env = Linen.kr(gate, 2, 1, 2, 2); // fade in the effect

		// call the wrapped function. The in and env arguments are passed to the function
		// as the first two arguments (prependArgs).
		// Any other arguments of the wrapped function will be Controls.
		sound = SynthDef.wrap(func, lags, [in, env]);

		XOut.ar(i_bus, wet * env, sound);
	}, [0, 0, 0.1]).add;

};
)
