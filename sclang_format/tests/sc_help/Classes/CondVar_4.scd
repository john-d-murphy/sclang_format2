// Source: Classes/CondVar.schelp block 4
(
var condition = CondVar();

// Our "unreliable" task will half the time signal us that it's done,
// but half the time it will fail to do so.
fork {
	var coinFlip;
	1.wait;
	coinFlip = 0.5.coin;
	postf("Flip gave us: % ; %signalling the condition\n", coinFlip,
		if(coinFlip, "not ", ""));
	if(coinFlip) { condition.signalOne };
};

fork {
	// In this case, the random coin flip succeeding is our entire
	// condition, so we don't pass any predicate to waitFor.
	if(condition.waitFor(2)) {
		"Coin flip succeeded!".postln
	} {
		"Coin flip failed, and we timed out".postln
	};
};
)
