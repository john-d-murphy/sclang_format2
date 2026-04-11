// Source: Tutorials/Mark_Polishook_tutorial/07_SynthDefs.schelp block 1
(
SynthDef(
	"aSynthDef", 				// the name of the synthdef
	{ 					// the ugenGraphFunc with actual code
		arg freq;
		Out.ar(
			0,
			SinOsc.ar(freq, 0, 0.1)
		)
	}
).load(s);
)
