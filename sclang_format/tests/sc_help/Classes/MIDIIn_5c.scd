// Source: Classes/MIDIIn.schelp block 5 (part 3/6)
(
var keys, cutspec, cutbus, rezspec, rezbus, lfospec, lfobus;
keys = Array.newClear(128);

MIDIClient.init;
MIDIIn.connect(0, MIDIClient.sources.at(0));

g = Group.new;

cutspec = ControlSpec(100,10000,\linear,0.001);
cutbus = Bus.new(\control,1,1,s);
cutbus.value = 10000;

rezspec = ControlSpec(1,0,\linear,0.001);
rezbus = Bus.new(\control,2,1,s);
rezbus.value = 1.0;

lfospec = ControlSpec(0,50,\linear,0.001);
lfobus = Bus.new(\control,3,1,s);

~control = {arg src, chan, num, val;
	if(num == 1,{
		rezbus.value = rezspec.map(val/127.0);
	});
	if(num == 7,{
		lfobus.value = lfospec.map(val/127.0).postln;
	});
};
MIDIIn.addFuncTo(\control, ~control);

~bend = {arg src, chan, val;
	cutbus.value = cutspec.map(val/16383.0);
};
MIDIIn.addFuncTo(\bend, ~bend);

~noteOn = {arg src, chan, num, vel;
	var node;
	if(num < 60, {
		node = Synth.tail(g, "funk", [\freq, num.midicps, \amp, vel/255]);
		node.map("cutoff",1,"rez",2,"lfospeed",3);
//		node = Synth.basicNew("funk",s);
//		s.sendBundle(nil,
//			node.addToTailMsg(g,[\freq, num.midicps, \amp, vel/255]),
//			node.mapMsg("cutoff",1,"rez",2,"lfospeed",3)
//		);
		keys.put(num, node)
	},{
		node = Synth.tail(g, "strings", [\freq, num.midicps, \amp, vel/255]);
		keys.put(num, node)
	});
};
MIDIIn.addFuncTo(\noteOn, ~noteOn);

~noteOff = {arg src, chan, num, vel;
	var node;
	node = keys.at(num);
	if (node.notNil, {
		keys.put(num, nil);
		s.sendMsg("/n_set", node.nodeID, "gate", 0);
		// or node.release
		// then free it ... or get the NodeWatcher to do it
	});
};
MIDIIn.addFuncTo(\noteOff, ~noteOff);
)
