// Source: Classes/MFCC.schelp block 1 (part 1/6)
(
var mel_freq_max, mel_freq_min, freq_bw_mel, freq_bands, freq_max, freq_min;
var mel_peak, lin_peak, fft_peak;
var freqperbin;
var fftbinstart, fftbinend, fftbinmult, fftbincumul;
var pos, tmp;
var sr, fftsize, halffftsize;
var whichbandscale, lintoscale, scaletolin;

freq_max = 18000;
freq_min = 80;
sr = 48000; //44100;
fftsize = 1024;
halffftsize = fftsize.div(2);
freq_bands = 42;

//whichbandscale = 0; // 0 = mel; 1 = bark (CB) 2 = ERB
//
//lintoscale = { |freq|
//switch(whichbandscale, 0, { 1127 * log(1 + (freq / 700))}, 1, { }, 2, { }).value
//};
//scaletolin = { |scalepos|
//switch(whichbandscale, 0, {700 * (exp(scalepos / 1127.0) -1) }, 1, { }, 2, { }).value
//};

lintoscale = { |freq|
	1127 * log(1 + (freq / 700))
};
scaletolin = { |scalepos|
	700 * (exp(scalepos / 1127.0) -1)
};

mel_freq_max = lintoscale.value(freq_max); // 1127 * log(1 + (freq_max / 700));
mel_freq_min = lintoscale.value(freq_min); //1127 * log(1 + (freq_min / 700));
freq_bw_mel = (mel_freq_max - mel_freq_min) / freq_bands;

[mel_freq_max, mel_freq_min, freq_bw_mel].postln;

mel_peak = Array.fill(freq_bands + 2, { 0.0 });
lin_peak = Array.fill(freq_bands + 2, { 0.0 });
fft_peak = Array.fill(freq_bands + 2, { 0.0 });

freqperbin = sr / fftsize; // SR/N

mel_peak[0] = mel_freq_min;
lin_peak[0] = freq_min; // === 700 * (exp(mel_peak[0] / 1127) - 1);
fft_peak[0] = (lin_peak[0] / freqperbin).asInteger;

for(1, freq_bands + 1, { |n|

	mel_peak[n] = mel_peak[n - 1] + freq_bw_mel;
	lin_peak[n] = scaletolin.value(mel_peak[n]); // 700 * (exp(mel_peak[n] / 1127.0) -1);
	fft_peak[n] = ((lin_peak[n] / freqperbin).asInteger).min(halffftsize); // fft size //rounds down here

});

//Post << mel_peak << nl;
//Post << lin_peak << nl;
//Post << fft_peak << nl;

//  [2 / (lin_peak[freq_bands + 1] - lin_peak[freq_bands-1]), 1.0 / (2 / (lin_peak[2] - lin_peak[0]))].postln;

fftbinstart = Array.fill(freq_bands, { 0 });
fftbinend = Array.fill(freq_bands, { 0 });
fftbincumul = Array.fill(freq_bands + 1, { 0 });
fftbinmult = [];

pos = 0;

freq_bands.do {|i|

	//var normmult = 1.0; // preserve power, don't modify band power by area
	var startbin, endbin, numbins, averager;

	if(i == 0) {
		startbin = 0;
		endbin = fft_peak[i + 1] - 1;
	} {
		startbin = fft_peak[i - 1] + 1;
		endbin = fft_peak[i + 1] - 1;
	};

	numbins = endbin - startbin + 1;
	averager = 1.0 / numbins;

	// linear crossfade (intended in power) between consecutive band centres

	tmp = fft_peak[i] - startbin;

	// could divide by averager but I'm not convinced by the perceptual necessity for this?
	// ie fftbinmult = fftbinmult ++ (Array.series(tmp + 1, 1.0 / (tmp + 1), 1.0 / (tmp + 1)) * averager);

	fftbinmult = fftbinmult ++ (Array.series(tmp + 1, 1.0 / (tmp + 1), 1.0 / (tmp + 1)));

	tmp = endbin - fft_peak[i];

	fftbinmult = fftbinmult ++ (Array.series(tmp, 1.0 + ((-1.0) / (tmp + 1)), (-1.0) / (tmp + 1)));

	fftbinstart[i] = startbin;
	fftbinend[i] = endbin;
	fftbincumul[i] = pos;

	pos = pos + (endbin - startbin + 1);
};

fftbincumul[freq_bands] = pos - 1;

Post << fftbinstart << nl;
Post << fftbinend << nl;
Post << fftbincumul << nl;
Post << fftbinmult << nl;

)
