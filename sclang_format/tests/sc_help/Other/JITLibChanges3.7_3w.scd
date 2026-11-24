// Source: Other/JITLibChanges3.7.schelp block 3 (part 23/248)
(
g = { |f, source|
	var n = 16;
	var a, b, proxy, pattern;
	proxy = EventPatternProxy.new;
	proxy.source = source;
	a = Pevent(f.(proxy)).asStream;
	b = Pevent(f.(proxy.source)).asStream;
	Array.fill(n, { a.next }).postln == Array.fill(n, { b.next }).postln
};
)
