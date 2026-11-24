// Source: Classes/IFFT.schelp block 0
(
{   var in, chain;
    in = WhiteNoise.ar;
    chain = FFT(LocalBuf(2048), in);
    IFFT.ar(chain) * -20.dbamp // inverse FFT
}.play;
)
