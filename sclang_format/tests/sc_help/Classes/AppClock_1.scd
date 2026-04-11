// Source: Classes/AppClock.schelp block 1
(
t = Main.elapsedTime;
"It is now % seconds after the computer booted.".format(t).postln;
AppClock.sched(2.0, { "It is now % sec later".format(Main.elapsedTime - t).postln; nil })
)
