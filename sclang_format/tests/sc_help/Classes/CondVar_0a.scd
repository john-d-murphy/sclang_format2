// Source: Classes/CondVar.schelp block 0 (part 1/2)
(
var c = CondVar();
// Our resource here will be a "message", which is set to some string
// when available, and set to empty when unavailable. This resource is
// initially unavailable.
var message = "";

// We add these delays to be clear about which thread runs first. Try
// changing these values to see what happens!
var waitThreadDelay = 1;
var signalThreadDelay = 2;

// These two forked threads will share the condition variable, `c`,
// and the condition state, `message`.
fork {
	waitThreadDelay.wait;
	while { message.isEmpty } {
		"Resource is unavailable, waiting now".postln;
		c.wait;
	};
	"Resource is available, message is: '%'\n".postf(message);
};

fork {
	signalThreadDelay.wait;
	message = "meow, world!";
	c.signalOne;
	"Resource was made available and waiting thread was signaled".postln;
};
)
