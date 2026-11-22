// Source: Classes/Semaphore.schelp block 1
(
c = Semaphore(2);
fork {
	c.wait;
	"thread 1> now I am doing something for 20 seconds. Block the semaphore.".postln;
	10.wait;
	"thread 1> ok, done. Releasing the semaphore".postln;
	c.signal;
};
fork {
	rrand(3.0, 5.0).wait;
	"thread 2> I would like to go on, if I may.".postln;
	if(c.count <= 0) { "thread 3> ok, then I wait ...".postln };
	c.wait; // may I?
	"thread 1> ok, going ahead.".postln;
	17.wait;
	"thread 2> ok, done. Releasing the semaphore".postln;
	c.signal;
};
fork {
	6.wait;
	"thread 3> I, too, would like to go on, if I may.".postln;
	if(c.count <= 0) { "thread 3> ok, then I wait ...".postln };
	c.wait; // may I?
	"thread 3> ok, this took until the first thread had released the semaphore. "
		"Ok, doing something for 4 seconds. Block the semaphore".postln;
		4.wait;
	"Releasing the semaphore.".postln;
	c.signal;
};
fork {
	7.wait;
	"thread 4> Me, the fourth one, would like to go on, if I may.".postln;
	if(c.count <= 0) { "thread 4> ok, then I wait ...".postln };
	c.wait; // may I?
	"thread 4> ok, this took until the third thread had released the semaphore. "
		"Ok, doing something for 3 seconds. Block the semaphore".postln;
		3.wait;
	"Releasing the semaphore.".postln;
	c.signal;
};
)
