// Source: Classes/Function.schelp block 41 (part 11/13)
(
try {
	protect { 123.postln; 456.throw; 789.postln } {|error| [\onExit, error].postln };
} {|error| [\catch, error].postln };
)
