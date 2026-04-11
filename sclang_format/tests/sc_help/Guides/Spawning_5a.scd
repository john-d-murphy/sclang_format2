// Source: Guides/Spawning.schelp block 5 (part 1/14)
(
// this, that and the other
r = Routine.new({var i = 0; { ("this: " ++ i).postln; i = i + 1; 1.yield; }.loop });
q = Routine.new({var i = 0; { ("that: " ++ i).postln; i = i + 1; 1.yield; }.loop });
t = Routine.new({var i = 0; { ("the other: " ++ i).postln; i = i + 1; 1.yield; }.loop });
)
