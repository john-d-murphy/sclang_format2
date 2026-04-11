// Source: Classes/Condition.schelp block 4 (part 2/2)
(
fork {
	10.do {
		"started a synth".postln;
		Synth(\help).waitForFree;
		"This one ended. Wait a second,  I will start the next one.".postln;
		1.wait;
	};
	"This is it.".postln;
}
);
