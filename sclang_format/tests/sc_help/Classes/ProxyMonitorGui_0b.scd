// Source: Classes/ProxyMonitorGui.schelp block 0 (part 2/38)
(
s.scope(8);
p = ProxySpace.push;

~test = { |freq = 1000, dens = 5, amp = 1, lev = 3|
	var freqline = { exprand(0.3, 3) } ! 3 * XLine.kr(0.125, 1, 2);
	Ringz.ar(Dust.ar(dens ! 3, dens.reciprocal.sqrt), freq * freqline, 0.1)
};
~test.playN(0, vol: 0.1);
)
