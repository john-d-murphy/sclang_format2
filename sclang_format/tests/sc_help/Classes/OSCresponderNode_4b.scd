// Source: Classes/OSCresponderNode.schelp block 4 (part 2/5)
a = OSCresponderNode(s.addr,'/n_end',{ arg time,responder,msg;
	[time, responder, msg].postln;
	if(msg[1] == g.nodeID,{
		"g is dead !".postln;
		// g = Group.new;
	});
}).add;
