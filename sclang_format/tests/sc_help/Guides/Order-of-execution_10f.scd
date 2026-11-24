// Source: Guides/Order-of-execution.schelp block 10 (part 6/9)
(
r = Routine({
	{
		Synth.tail(~synthgroup, "order-of-ex-pulse",
			[\freq, rrand(200, 800), \ffreq, rrand(1000, 15000), \pan, 1.0.rand2,
			\bus, b, \lfobus, l]);
		0.07.wait;
	}.loop;
}).play(SystemClock);
)
