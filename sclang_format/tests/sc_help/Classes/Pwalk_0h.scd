// Source: Classes/Pwalk.schelp block 0 (part 8/9)
(
r = Task({
	{
		Synth.new(\help_walk, [\freq, x.next]);
		0.1.wait;
	}.loop;
}).play(SystemClock);
)
