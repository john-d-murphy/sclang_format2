// Source: Classes/DiskIn.schelp block 1 (part 14/14)
(
x = Synth.basicNew("help-Diskin");
m = { |buf| x.addToHeadMsg(nil, [\bufnum, buf.bufnum]) };

b = Buffer.cueSoundFile(s, ExampleFiles.apollo11, 0, 1, completionMessage: m);

)
