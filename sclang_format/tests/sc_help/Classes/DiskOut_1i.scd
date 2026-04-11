// Source: Classes/DiskOut.schelp block 1 (part 9/12)
(
x = Synth.basicNew("help-Diskin-2chan");
m = { |buf| x.addToHeadMsg(nil, [\bufnum,buf])};

b = Buffer.cueSoundFile(s,"~/diskouttest.wav".standardizePath, 0, 2, completionMessage: m);
)
