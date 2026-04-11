// Source: Classes/BeatTrack2.schelp block 2 (part 1/2)
(
a= SynthDef(\help_beattrack2_1, { |out, vol=1.0, beepvol=1.0, lock=0, bufnum|
	var in, kbus;
	var trackb, trackh, trackq, tempo, phase, period, groove;
	var bsound, hsound, qsound, beep;
	var fft;
	var feature1, feature2, feature3;

	in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum),1,0,1);
	//in = SoundIn.ar(0);

	//Create some features
	fft = FFT(LocalBuf(1024), in); // for sampling rates 44100 and 48000
	//fft = FFT(LocalBuf(2048), in); // for sampling rates 88200 and 96000

	feature1 = Onsets.kr(fft, odftype:\mkl, rawodf:1);

	feature2 = Onsets.kr(fft, odftype:\complex, rawodf:1);//two coefficients

	kbus= Out.kr(0, [feature1,feature2]);

	//Look at four features
	#trackb, trackh, trackq, tempo, phase, period, groove = BeatTrack2.kr(0, 2, 3.0, 0.02, lock, -2.5);


	beep = SinOsc.ar(1000, 0.0, Decay.kr(trackb, 0.1));
	beep = Pan2.ar((vol * in) + (beepvol * beep), 0.0);
	Out.ar(out, beep);
}).add;
)
