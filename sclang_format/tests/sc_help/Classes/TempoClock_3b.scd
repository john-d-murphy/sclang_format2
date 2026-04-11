// Source: Classes/TempoClock.schelp block 3 (part 2/3)
(
c = TempoClock.new;
fork {
    loop {
		c.beats.postln; // updates, because ".wait" calls the thread
        1.wait;
    }
};
)
