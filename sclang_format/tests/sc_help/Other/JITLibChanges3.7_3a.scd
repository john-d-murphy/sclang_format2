// Source: Other/JITLibChanges3.7.schelp block 3 (part 1/248)
(
g = { |f, source, firstSource|
	var n = 16;
	var a, b, proxy, pattern;
	proxy = PatternProxy.new;
	a = f.(proxy).asStream;
	if(firstSource.notNil) { proxy.source = firstSource; n.do { a.next } };
	proxy.source = source;
	b = f.(source).asStream;
	Array.fill(n, { a.next }).postln == Array.fill(n, { b.next }).postln
};
h = { |f, source|
	g.(f, source, Pseq([-1], inf));
}
)
