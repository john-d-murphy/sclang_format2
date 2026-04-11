// Source: Guides/ListComprehensions.schelp block 7 (part 1/3)
(
var intervals;
// a function to generate intervals between all pairs of notes in a chord voicing
intervals = {|chord|
	all {: chord[i+gap] - chord[i],
		gap <- (1 .. chord.lastIndex),
		i <- (0 .. chord.lastIndex - gap)
	}
};

intervals.([0,4,7,10]).postln;
intervals.([0,1,3,7]).postln;
)
