// Source: Classes/Routine.schelp block 6 (part 9/10)
(
u = PauseStream(t.stream);
TempoClock.schedAbs(t.nextBeat.trunc, u.refresh);
t.stop;
)
