// Source: Classes/VOsc3.schelp block 0 (part 6/7)
(
var a = Array.fill(64, { 1.0.rand2 });
var n = [1, a.size].interpolate(~bufs.size-1);
~bufs.do({ |buf, i|
	n[i].postln;
	s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a.keep(n[i].asInteger).postln);
});
)
