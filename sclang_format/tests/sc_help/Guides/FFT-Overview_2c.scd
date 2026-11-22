// Source: Guides/FFT-Overview.schelp block 2 (part 3/4)
(
var dt = s.options.blockSize / s.sampleRate * 16; // plot 16 blocks
var min = -2, max = b.bufnum + 4;
// input is SoundIn, but we don't see this signal
{ FFT(b, SoundIn.ar) }.plot(dt, minval:min, maxval:max).plotMode_(\steps);
)
