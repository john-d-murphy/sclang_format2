// Source: Overviews/Operators.schelp block 30 (part 2/2)
(
{
	var x, y, distance, velocity, pitchRatio, amplitude, motorSound,
			azimuth, panValue;
	// object travels 200 meters in 6 secs (=120kph) passing 10 meters
	// from the listener
	x = 10;
	y = LFSaw.kr(1/6, 0, 100);
	distance = hypot(x, y);
	amplitude = 40 / distance.squared;
	motorSound = RLPF.ar(FSinOsc.ar(200, 0, LFPulse.ar(31.3, 0, 0.4)), 400, 0.3);
	azimuth = atan2(y, x); // azimuth in radians
	panValue = (azimuth / 0.5pi).clip2(1); // make a value for Pan2 from azimuth
	Pan2.ar(DelayL.ar(motorSound, 110/344, distance/344), panValue, amplitude)
}.play)
