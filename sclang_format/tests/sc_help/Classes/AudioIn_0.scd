// Source: Classes/AudioIn.schelp block 0
(
ServerOptions.inDevices.postln;	//  post available audio input devices
s.meter;	// display level meters for monitoring
SynthDef(\helpAudioIn, { |out|
	var input = AudioIn.ar(1); // first input
	// delay output to tame feedback in case of microphones are configured:
	Out.ar(out, CombN.ar(input * -25.dbamp, 0.5, 0.5, 0.001))
}).play
)
