// Source: Classes/MIDIIn.schelp block 2
(
	var inPorts = 2;
	var outPorts = 2;
	MIDIClient.init(inPorts,outPorts);	// explicitly intialize the client
	inPorts.do({ arg i;
		MIDIIn.connect(i, MIDIClient.sources.at(i));
	});
)
