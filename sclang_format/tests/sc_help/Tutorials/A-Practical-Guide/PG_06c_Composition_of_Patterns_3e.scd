// Source: Tutorials/A-Practical-Guide/PG_06c_Composition_of_Patterns.schelp block 3 (part 5/6)
~melody.source = Pbind(\degree, Pseries(4, Pwrand(#[-2, -1, 1, 2], #[0.3, 0.2, 0.2, 0.3], inf), inf).fold(-4, 11));
