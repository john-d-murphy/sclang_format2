// Source: Classes/MIDIClient.schelp block 0 (part 1/2)
(
~connect_midi_devices = { arg device, name;
	// init or refresh MIDIClient end points
	if(MIDIClient.initialized == false) {
		MIDIClient.init;
	} {
		MIDIClient.list;
	};

	MIDIClient.sources.do({ arg endPoint;
		if(device.notNil and: { name.notNil} and: {endPoint.device == device} and: { endPoint.name == name }) {
			// catch exception thrown when already connected
			try {
				// connect SuperCollider out port 0 to MIDI device
				MIDIOut.connect(0, endPoint.uid);
			};
			try {
				// connect MIDI device to SuperCollider in port 0
				MIDIIn.connect(0, endPoint.uid);
			}
		}
	})

}
)
