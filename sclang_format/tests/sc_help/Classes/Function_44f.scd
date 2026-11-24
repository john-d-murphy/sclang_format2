// Source: Classes/Function.schelp block 44 (part 6/8)
(
try {
	protect { 123.postln; 456.throw; 789.postln } { |error| [\onExit, error].postln };
} { |error| [\catch, error].postln };
)
