// Source: Guides/Non-Realtime-Synthesis.schelp block 14
(
fork {
	var server = Server(\nrt,
		options: ServerOptions.new
		.numOutputBusChannels_(2)
		.numInputBusChannels_(2)
	);
	var resultbuf, resultpath, oscpath, score, dur, sf, cond, size, data;

	// get duration
	sf = SoundFile.openRead(ExampleFiles.child);
	dur = sf.duration;
	sf.close;

	resultpath = PathName.tmp +/+ UniqueID.next ++ ".wav";
	oscpath = PathName.tmp +/+ UniqueID.next ++ ".osc";

	score = Score([
		[0, (resultbuf = Buffer.new(server, 1000, 1, 0)).allocMsg],
		[0, [\d_recv, SynthDef(\onsets, {
			var sig = SoundIn.ar(0), // will come from NRT input file
			fft = FFT(LocalBuf(512, 1), sig),
			trig = Onsets.kr(fft),
			// count the triggers: this is the index to save the data into resultbuf
			i = PulseCount.kr(trig),
			// count time in seconds
			timer = Sweep.ar(1);
			// 'i' must be audio-rate for BufWr.ar
			BufWr.ar(timer, resultbuf, K2A.ar(i), loop: 0);
			BufWr.kr(i, resultbuf, DC.kr(0), 0);  // # of points in index 0
		}).asBytes]],
		[0, Synth.basicNew(\onsets, server, 1000).newMsg],
		[dur, resultbuf.writeMsg(resultpath, headerFormat: "wav", sampleFormat: "float")]
	]);

	cond = Condition.new;

	// osc file path, output path, input path - input is soundfile to analyze
	score.recordNRT(oscpath, "/dev/null", sf.path, sampleRate: sf.sampleRate,
		options: ServerOptions.new
			.verbosity_(-1)
			.numInputBusChannels_(sf.numChannels)
			.numOutputBusChannels_(sf.numChannels)
			.sampleRate_(sf.sampleRate),
		action: { cond.unhang }  // this re-awakens the process after NRT is finished
	);
	cond.hang;  // wait for completion

	sf = SoundFile.openRead(resultpath);
	// get the size: one frame at the start
	sf.readData(size = FloatArray.newClear(1));
	size = size[0];
	// now the rest of the data
	sf.readData(data = FloatArray.newClear(size));
	sf.close;

	File.delete(oscpath);
	File.delete(resultpath);
	server.remove;

	data.postln;  // these are your onsets!
};
)
