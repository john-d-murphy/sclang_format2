// Source: Classes/BufDur.schelp block 0 (part 2/3)
{ BufRd.ar(1, b,  Sweep.ar(Impulse.ar(BufDur.kr(b).reciprocal), BufSampleRate.kr(b))) }.play;
