// Source: Classes/VDiskIn.schelp block 0 (part 16/20)
(
o = OSCFunc({ |msg|
	var sendID = msg[2];
	var index = msg[3];
	msg.postln;
	"id: % pos: % frames (% sec)\n"
		.postf(sendID, index % c.numFrames, (index % c.numFrames / c.sampleRate));
}, '/diskin', s.addr)
);
