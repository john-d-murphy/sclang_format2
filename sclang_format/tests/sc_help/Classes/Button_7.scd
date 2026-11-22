// Source: Classes/Button.schelp block 7
(
s.waitForBoot({
	var update, w, b;

	w = Window.new("State Window", Rect(150, Window.screenBounds.height - 140, 380, 60));

	// a convenient way to set the button label
	update = { |but, string|
	but.states = [[string.asString, Color.black, Color.red]]; but.refresh };

	b = Button(w, Rect(10, 10, 360, 40));
	b.font_(Font("Impact", 24));

	update.value(b, "there is only one state");

	// if an action should do something different each time it is called, a routine is the
	// right thing to use. This is better than creating variables outside and setting them
	// from the action function to keep state from one action to the next

	b.action_(Routine { |butt|
		var synth, guessVal;

		update.value(butt, "there are only two states");
		0.yield; // stop here

		update.value(butt, "click me");
		0.yield; // stop here

		update.value(butt, "click me again");
		0.yield; // stop here ..

		// create a synth
		synth = { |freq = 1000, rate = 5|
			Ringz.ar(
				Impulse.ar(rate.lag(4) * [1, 1.01]), freq, rrand(0.01, 0.1), 0.3
			)
		}.play;
		0.yield;

		guessVal = exprand(200.0, 18000).round;
		synth.set(\freq, guessVal); // set the synth
		update.value(butt, "?");
		0.yield;

		update.value(butt, guessVal.asString + "Hz"); // display frequency
		0.yield;

		synth.set(\rate, rrand(10, 50)); // set trigger rate
		// start an independent process
		fork({ 5.wait; synth.release; update.value(butt, "."); 1.wait; w.close }, AppClock);
	});
	CmdPeriod.doOnce({ w.close });
	w.front;
});
)
