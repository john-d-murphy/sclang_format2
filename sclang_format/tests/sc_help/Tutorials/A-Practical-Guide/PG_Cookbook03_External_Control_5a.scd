// Source: Tutorials/A-Practical-Guide/PG_Cookbook03_External_Control.schelp block 5 (part 1/2)
var	amp = Amplitude.kr(In.ar(inbus, 1), attackTime: 0.01, releaseTime: decay),
		trig = HPZ1.kr(amp >= thresh);
