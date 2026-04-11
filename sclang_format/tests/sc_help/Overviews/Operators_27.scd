// Source: Overviews/Operators.schelp block 27
(
{
	var x, y, distance, velocity, pitchRatio, amplitude;
	// object travels 200 meters in 6 secs (=120kph) passing 10 meters
	// from the listener
	x = 10;
	y = LFSaw.kr(1/6, 0, 100);
	distance = hypot(x, y);
	velocity = Slope.kr(distance);
	pitchRatio = (344 - velocity) / 344;  // speed of sound is 344 meters/sec
	amplitude = 10 / distance.squared;
	FSinOsc.ar(1000 * pitchRatio, 0, amplitude)
}.play)
