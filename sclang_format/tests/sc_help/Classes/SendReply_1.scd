// Source: Classes/SendReply.schelp block 1
(
{ SendReply.ar(Impulse.ar(4), "/reply", [Sweep.ar, SinOsc.ar(0.3)]); 0 }.play;
OSCdef(\x, { |msg|
	var time, value;
	time = msg[3];
	value = msg[4];
	"value % occurred at time %".format(value, time).postln;
}, "/reply");
)
