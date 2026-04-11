// Source: Classes/LocalOut.schelp block 0 (part 1/4)
(
{
	var source, local;

	source = Decay.ar(Impulse.ar(0.3), 0.1) * WhiteNoise.ar(0.2);
	local = LocalIn.ar(2) + [source, 0]; // read feedback, add to source
	local = DelayN.ar(local, 0.2, 0.2); // delay sound

	// reverse channels to give ping pong effect, apply decay factor
	LocalOut.ar(local.reverse * 0.8);

	local
}.play;
)
