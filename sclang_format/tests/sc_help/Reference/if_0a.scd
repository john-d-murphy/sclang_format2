// Source: Reference/if.schelp block 0 (part 1/2)
if ( [false, true].choose,				// Boolean expression (chooses one at random)
	{ "expression was true".postln },	// true function
	{ "expression was false".postln }	// false function
)
