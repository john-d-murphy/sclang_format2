// Source: Classes/Pfsm.schelp block 0 (part 3/3)
(
Pfsm([
	#[5, 6, 7], // entry states

	// e1 (== state 0)
	Pbind(\dur, Pseq([1/8, 3/8]), \midinote, Pseq([86, 75])),
	// #[1],	// as given in CMJ
	// my de-boredom-ated version..
	#[1, 1, 1, 1, 1, 1, 1, 8],
	// e2 (== state 1)
	Pbind(\dur, 1/2, \midinote, Pseq([69])),
	#[0, 1],
	// e3 (== state 2)
	Pbind(\dur, 1/3, \midinote, Pseq([55, 60, 66])),
	#[0, 1, 2, 2, 2, 2, 3, 3, 3, 3],
	// e4 (== state 3)
	Pbind(\dur, 1/4, \midinote, Pseq([81, 80, 77, 76])),
	#[1, 4, 4, 4, 4],
	// e5 (== state 4)
	Pbind(\dur, Pseq([1, 2/3, 2/3, 2/3, 1]), \midinote, Pseq([\, 70, 70, 70, \])),
	#[2, 3],
	// e6 (== state 5)
	Pbind(\dur, 1/4, \midinote, Pseq([59, 61])),
	#[0, 2, 4, 5, 5, 5, 5, 5, 5, 5],
	// e7 (== state 6)
	Pbind(\dur, 1/4, \midinote, Pseq([87, 88], 2)),
	#[4, 4, 4, 4, 6, 6, 6, 7, 7, 7],
	// e8 (== state 7)
	Pbind(\dur, 1, \midinote, Pseq([56])),
	#[1, 3, 6, 6, 6],
	// terminal state
	nil, nil
]).play;
)
