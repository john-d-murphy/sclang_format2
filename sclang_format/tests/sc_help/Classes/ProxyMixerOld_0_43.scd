// Source: Classes/ProxyMixerOld.schelp block 0 (part 44/49)
(		// test too many
10.do { |i| p[("test" ++ i).asSymbol] = {
	Pan2.ar(Ringz.ar(Impulse.ar(exprand(0.5, 4)), exprand(300, 3000), 0.02), 1.0.rand2, 0.2) };
};
)
