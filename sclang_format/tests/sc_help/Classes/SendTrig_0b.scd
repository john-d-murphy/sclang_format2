// Source: Classes/SendTrig.schelp block 0 (part 2/4)
(
SynthDef("help-SendTrig",{
	SendTrig.kr(Dust.kr(1.0),0,0.9);
}).add;

// register to receive this message
o = OSCFunc({ arg msg, time;
	[time, msg].postln;
},'/tr', s.addr);
)
