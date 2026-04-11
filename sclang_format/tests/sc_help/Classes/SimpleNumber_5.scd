// Source: Classes/SimpleNumber.schelp block 5
(
var start;
start = Main.elapsedTime;
{
	loop {
		(Main.elapsedTime - start).asTimeString.postln;
		0.05.wait
	}
}.fork;
)
