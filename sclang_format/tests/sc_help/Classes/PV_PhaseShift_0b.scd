// Source: Classes/PV_PhaseShift.schelp block 0 (part 2/2)
(
SynthDef("help-phaseShift", { arg out=0;
        var in, chain;
        in = SinOsc.ar(500);
        chain = FFT(LocalBuf(2048), in);
        chain = PV_PhaseShift(chain, LFNoise2.kr(1, 180, 180));
        Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)
