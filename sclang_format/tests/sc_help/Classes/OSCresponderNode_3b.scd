// Source: Classes/OSCresponderNode.schelp block 3 (part 2/6)
(
SynthDef("help-SendTrig",{
	SendTrig.kr(Dust.kr(1.0), 0, 0.9);
}).add;

// register to receive this message
a = OSCresponderNode(s.addr, '/tr', { arg time, responder, msg;
	[time, responder, msg].postln;
}).add;
b = OSCresponderNode(s.addr, '/tr', { arg time, responder, msg;
	"this is another call".postln;
}).add;
)
