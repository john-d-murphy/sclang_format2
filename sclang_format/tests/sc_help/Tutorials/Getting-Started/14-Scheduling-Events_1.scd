// Source: Tutorials/Getting-Started/14-Scheduling-Events.schelp block 1
(
var timeNow = TempoClock.default.beats;
"Time is now: ".post; timeNow.postln;
"Scheduling for: ".post; (timeNow + 5).postln;
TempoClock.default.schedAbs(timeNow + 5,
	{ "Time is later: ".post; thisThread.clock.beats.postln; nil });
)
