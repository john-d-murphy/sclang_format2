// Source: Classes/KeyTrack.schelp block 3
(
var fftN, fftBins, binsize;
var midinotes;
var sr;
var wtlist, binlist;

sr = 48000; // 44100;

fftN = 4096;
fftBins = fftN.div(2);
binsize = sr / fftN;

midinotes = (33..92); // 60 notes, 55 Hz up to 1661.2187903198 Hz

wtlist = List[];
binlist = List[];

// for each note have six harmonic locations
midinotes.do{ |note|
	var freq, whichbin, lowerbin, prop;

	freq = note.midicps;

	6.do{ |j|
		var partialfreq, partialamp;

		partialamp = 1.0 / (j + 1);
		partialfreq = freq * (j + 1);

		whichbin = partialfreq / binsize;
		lowerbin = whichbin.asInteger;
		prop = 1.0 - (whichbin - lowerbin);

		binlist.add(lowerbin).add(lowerbin + 1);
		wtlist.add(prop * partialamp).add((1.0 - prop) * partialamp);

	};

};


Post << (binlist) << nl<< nl;

Post << (wtlist) << nl<< nl;

binlist.size.postln;
wtlist.size.postln;
)
