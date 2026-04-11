// Source: Classes/Function.schelp block 42 (part 4/4)
(
protect {
	a = [\aaa, \bbb, \ccc, \ddd];
	a[1].postln;
	a[\x].postln;
	a[2].postln;
} {|error| \caught.postln; error.dump }
)
