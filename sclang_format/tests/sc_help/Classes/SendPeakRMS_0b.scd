// Source: Classes/SendPeakRMS.schelp block 0 (part 2/3)
(
o = OSCFunc({ |msg|
	"peak: %, rms: %".format(msg[3], msg[4]).postln
}, '/replyAddress');
)
