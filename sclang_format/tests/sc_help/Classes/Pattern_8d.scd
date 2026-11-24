// Source: Classes/Pattern.schelp block 8 (part 4/27)
(
{ var printStream;
	printStream = CollStream.new;
	Pseq([Ptrace(r, \freq, printStream), Pfunc({ printStream.collection.dump; nil })]).play;
}.value;
)
