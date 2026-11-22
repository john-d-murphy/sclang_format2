// Source: Classes/ProxyMixer.schelp block 0 (part 8/8)
"abcdefghijk".do { |k, i|
	p[k.asSymbol].playN(vol: 0.8 - (0.1 * i));
	p[k.asSymbol].source = {
		VarSaw.ar((i + 1 * 100) + [-1, 1])
		* LFSaw.ar((i + 1 * 0.25));
	};
};
