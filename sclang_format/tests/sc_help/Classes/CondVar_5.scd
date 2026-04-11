// Source: Classes/CondVar.schelp block 5
(
var condition = CondVar();
var coinFlip = false;

fork {
	// The coin flip now has multiple chances to succeed, but it still
	// might not do so within our 2-second window.
	5.do { |i|
		0.2.wait;
		coinFlip = 0.25.coin;
		"Flip number %: got %\n".postf(i + 1, coinFlip);
		condition.signalOne;
	}
};

fork {
	// We don't exit `waitFor` unless we timeout, or we get signalled
	// *and* the predicate is true.
	if(condition.waitFor(2, { coinFlip })) {
		"Coin flip succeeded!".postln
	} {
		"Coin flip failed, and we timed out".postln
	};
};
)
