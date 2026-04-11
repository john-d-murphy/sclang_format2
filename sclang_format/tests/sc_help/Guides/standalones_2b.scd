// Source: Guides/standalones.schelp block 2 (part 2/9)
(
// 5. write a basic startupFile:
~startupCode =
"// basic example startup file for osx standalone.
// avoid clash with default SC server
s.addr.port = 57105;

// boots server and plays a little sound
s.waitForBoot {
	{
		Line.kr(1, 0, 10, doneAction: 2) * SinOsc.ar(1000)
		* EnvGen.ar(Env.perc(0.01, 0.25), Impulse.kr(2, [0, 0.5]), 0.1)

	}.play;
};
";
~writeText.(~newAppResDir +/+ "startup.scd", ~startupCode);
(~newAppResDir +/+ "startup.scd").openOS;
)
