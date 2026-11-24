// Source: Guides/Sync-Async.schelp block 9 (part 1/2)
(
b = Buffer.alloc(s, 44100,
	completionMessage: { arg buffer; ("bufnum:" + buffer).postln; }
);
)
