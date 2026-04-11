// Source: Classes/DelTapWr.schelp block 1 (part 3/8)
SynthDef(\readFilt, { |out, buffer, cin|
	var phase, src, filt;
	phase = In.kr(cin);
	src = DelTapRd.ar(buffer, phase, [0.01, 0.2]);
	filt = BPF.ar(src, 880, 0.01) * 10;
	Out.ar(out, filt);
}).add;
