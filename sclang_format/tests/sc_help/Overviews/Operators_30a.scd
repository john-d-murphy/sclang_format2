// Source: Overviews/Operators.schelp block 30 (part 1/2)
(
{
	var x, y, distance, velocity, pitchRatio, amplitude, azimuth, panValue;
	// object travels 200 meters in 6 secs (=120kph) passing 10 meters
	// from the listener
	x = 10;
	y = LFSaw.kr(1/6, 0, 100);
	distance = hypot(x, y);
	velocity = Slope.kr(distance);
	pitchRatio = (344 - velocity) / 344;  // speed of sound is 344 meters/sec
	amplitude = 10 / distance.squared;
	azimuth = atan2(y, x); // azimuth in radians
	panValue = (azimuth / 0.5pi).clip2(1);
	Pan2.ar(FSinOsc.ar(1000 * pitchRatio), panValue, amplitude)
}.play)
