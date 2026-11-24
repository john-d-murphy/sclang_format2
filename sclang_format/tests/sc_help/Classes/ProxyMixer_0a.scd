// Source: Classes/ProxyMixer.schelp block 0 (part 1/8)
(
p = ProxySpace.push(s.boot, p);
"abcde".do { |k| p[k.asSymbol].ar };
m = ProxyMixer(p, 8);
m.parent.alwaysOnTop_(true); // show mixer in front of IDE
)
