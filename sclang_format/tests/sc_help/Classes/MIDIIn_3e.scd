// Source: Classes/MIDIIn.schelp block 3 (part 5/8)
(
~noteOn = {arg src, chan, num, vel;
	x.set(\freq, num.midicps / 4.0);
	x.set(\gate, vel / 200 );
	x.set(\formfreq, vel / 127 * 1000);
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);

~noteOff = { arg src,chan,num,vel;
	x.set(\gate, 0.0);
};
MIDIIn.addFuncTo(\noteOff, ~noteOff);

~bend = { arg src,chan,val;
	//(val * 0.048828125).postln;
	x.set(\bwfreq, val * 0.048828125 );
};
MIDIIn.addFuncTo(\bend, ~bend);
)
