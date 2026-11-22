// Source: Classes/SoundFile.schelp block 6 (part 11/14)
a = { (PlayBuf.ar(1, b, rate: 440 * 1024/44100, loop: 1) * 0.1).dup }.play;
