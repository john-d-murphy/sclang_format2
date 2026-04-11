// Source: Tutorials/A-Practical-Guide/PG_06c_Composition_of_Patterns.schelp block 3 (part 1/6)
~rhythm = EventPatternProxy(Pbind(
	\dur, Pwrand(#[0.125, 0.25, 0.5], #[0.3, 0.5, 0.2], inf),
	\legato, Pwrand(#[0.1, 0.6, 1.01], #[0.1, 0.3, 0.6], inf)
));
