// Source: Classes/Fdef.schelp block 1 (part 2/7)
(
Fdef(\freq, 440);
Fdef(\dur, 0.2);

fork {
	loop {
		s.sendMsg("/s_new", "gpdef", -1, 1,1, \freq, Fdef(\freq).value);
		Fdef(\dur).value.wait;
	}
};
)
