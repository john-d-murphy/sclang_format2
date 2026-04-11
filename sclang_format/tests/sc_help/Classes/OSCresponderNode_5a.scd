// Source: Classes/OSCresponderNode.schelp block 5 (part 1/4)
f = OSCresponderNode(s.addr, '/fail', { arg time, responder, msg;
	{
		var mins,secs;
		mins = (time/60).round(1);
		secs = (time%60).round(0.1);
		if(secs<10,{ secs = "0"++secs.asString; },{ secs=secs.asString;});
		// put this on a gui
		//errors.label = "% % (%:%)".format(msg[1], msg[2], mins, secs);
		//errors.stringColor = Color.white;
		"% % (%:%)".format(msg[1], msg[2], mins, secs).postln;
	}.defer
});
