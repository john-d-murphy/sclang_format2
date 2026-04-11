// Source: Guides/Randomness.schelp block 5 (part 1/2)
(
5.do({
	thisThread.randSeed = 4;
	Array.fill(10, { 1000.linrand}).postln;
});
)
