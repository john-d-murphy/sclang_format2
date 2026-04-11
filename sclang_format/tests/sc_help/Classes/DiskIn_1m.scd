// Source: Classes/DiskIn.schelp block 1 (part 13/13)
(
x = Synth.basicNew("help-Diskin");
m = { arg buf; x.addToHeadMsg(nil, [\bufnum, buf.bufnum])};

b = Buffer.cueSoundFile(s,Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff", 0, 1, completionMessage: m);

)
