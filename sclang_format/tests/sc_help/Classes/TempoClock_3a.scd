// Source: Classes/TempoClock.schelp block 3 (part 1/3)
(
t = TempoClock.new;

t.sched(3, {
    t.beats = 100;
    t.beats.postln; // still 3
    nil
});
)
