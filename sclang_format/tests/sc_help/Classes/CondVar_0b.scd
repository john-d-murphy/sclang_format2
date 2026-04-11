// Source: Classes/CondVar.schelp block 0 (part 2/2)
(
var c = CondVar(), message = "";
var waitThreadDelay = 1;
var signalThreadDelay = 2;

fork {
	waitThreadDelay.wait;
	c.wait({ message.notEmpty });
	"Resource is available, message is: '%'\n".postf(message);
};

fork {
	signalThreadDelay.wait;
	message = "meow, world!";
	c.signalOne;
	"Resource was made available and waiting thread was signaled".postln;
};
)
