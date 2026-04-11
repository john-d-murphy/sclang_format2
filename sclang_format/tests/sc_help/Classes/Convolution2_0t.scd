// Source: Classes/Convolution2.schelp block 0 (part 20/24)
(
//must have power of two framesize- FFT size will be sorted by Convolution2 to be double this
//maximum is currently a=8192 for FFT of size 16384
a=2048;
s = Server.local;
//kernel buffer
g = Buffer.alloc(s,a,1);
)
