// Source: Tutorials/A-Practical-Guide/PG_08_Event_Types_and_Parameters.schelp block 6 (part 4/5)
p = Pbind(
	\type, \setProperties,
	\receiver, x,
		// this means, call x.value_() on every event
	\args, [\value],
		// and look for the value under \value
	\value, Pbrown(0, 1, 0.1, inf),
	\delta, 0.1
).play;
