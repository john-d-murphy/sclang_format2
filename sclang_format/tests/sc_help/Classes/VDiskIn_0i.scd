// Source: Classes/VDiskIn.schelp block 0 (part 9/20)
(
x = Synth.basicNew("help-VDiskin");
m = { |buf| x.addToHeadMsg(nil, [\bufnum, buf]) };

b = Buffer.cueSoundFile(s, ExampleFiles.apollo11, 0, 1, completionMessage: m);
)
