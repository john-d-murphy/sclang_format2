// Source: Classes/Convolution.schelp block 0 (part 2/3)
(
// must have power of two framesize- FFT size will be sorted by Convolution to be double this
// maximum is currently a=8192 for FFT of size 16384

a = 2048;
s = Server.local;

// kernel buffer
g = Buffer.alloc(s, a, 1);
)
