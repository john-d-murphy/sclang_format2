// Source: Classes/Dictionary.schelp block 36 (part 1/4)
(
d = (
	a: 5, b: 7, c: 1,
	rout: Routine { |inval|
		inf.do { |i|
			var event = d.copy.put(\count, i);
			inval = event.embedInStream(inval);
		}
	}
);
)
