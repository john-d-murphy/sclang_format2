// Source: Classes/AppClock.schelp block 2
(
t = Main.elapsedTime;
"It is now % seconds after the computer booted.".format(t).postln;
AppClock.schedAbs(t + 1.0, { "It is now % sec later".format(Main.elapsedTime - t).postln; nil })
)
