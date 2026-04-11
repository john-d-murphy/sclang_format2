// Source: Classes/OSCpathResponder.schelp block 0 (part 2/7)
(
	var commandpath, response, aSynth, nodeID, triggerID;
	triggerID = 1;
	aSynth = { arg freq = 1, triggerID = 1;
		SendTrig.kr(SinOsc.kr(freq), triggerID, 666)
	}.play;
	nodeID = aSynth.nodeID;
	commandpath = ['/tr', nodeID, triggerID];
	response = { arg time, responder, message; message.postln };

	o = OSCpathResponder(s.addr, commandpath, response);
	o.add;
)
