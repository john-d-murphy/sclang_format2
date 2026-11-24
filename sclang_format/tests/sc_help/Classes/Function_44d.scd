// Source: Classes/Function.schelp block 44 (part 4/8)
protect { 123.postln; 456.throw; 789.postln } { |error| [\onExit, error].postln };
