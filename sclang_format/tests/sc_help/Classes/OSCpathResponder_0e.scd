// Source: Classes/OSCpathResponder.schelp block 0 (part 5/7)
(
	var commandpath, response, aSynth, nodeID, triggerID;
	triggerID = 1;
	aSynth = { arg freq = 1, triggerID = 1;
		SendTrig.kr(SinOsc.kr(freq), triggerID, 666)
	}.play;
	nodeID = aSynth.nodeID;
	commandpath = [nodeID, triggerID];
	response = { arg message; message.postln };

	o = OSCFunc(response, '/tr', s.addr, argTemplate: commandpath);

)
