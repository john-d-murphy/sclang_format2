// Source: Classes/Function.schelp block 45 (part 2/4)
(
try {
	a = [\aaa, \bbb, \ccc, \ddd];
	a[1].postln;
	a[\x].postln;
	a[2].postln;
} { |error| \caught.postln; error.dump }
)
