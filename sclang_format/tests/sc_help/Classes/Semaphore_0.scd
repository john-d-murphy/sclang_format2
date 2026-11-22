// Source: Classes/Semaphore.schelp block 0
(
c = Semaphore(1);
fork {
	c.wait;
	"thread 1> now I am doing something for 10 seconds. Block the semaphore meanwhile.".postln;
	10.wait;
	c.signal;
	"thread 1> ok, done. Release the semaphore.".postln;
};
fork {
	3.0.rand.wait;
	"thread 2> I would like to go on, if I may.".postln;
	c.wait; // may I?
	"thread 2> this took until the other thread has released the semaphore. "
		"Blocking for 4 seconds.".postln;
	4.wait;
	"thread 2> ok, done. Releasing the semaphore".postln;
	c.signal;
};
fork {
	4.wait;
	"thread 3> I, too, would like to go on, if I may.".postln;
	c.wait; // may I?
	"thread 3> this took until both other threads had released the semaphore.".postln;
	c.signal;
};
)
