// Source: Classes/NodeProxy.schelp block 9 (part 7/11)
b.source = { |freq = 1000| SinOsc.ar(freq * 3 * {{ rrand(0.9, 1.1) }.dup(8) }.dup(2)).mean * 0.5 };
