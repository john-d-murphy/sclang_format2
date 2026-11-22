// Source: Classes/Association.schelp block 1
(
a = [\x -> 700, \y -> 200, \z -> 900];

fork {
	a.do { |assoc|
		assoc.key.postln;
		assoc.value.postln;
		(freq: assoc.value).play;
		2.wait;
	}
};
)
