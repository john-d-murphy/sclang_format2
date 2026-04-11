// Source: Classes/NodeProxy.schelp block 17 (part 17/70)
a[3] = { SinOsc.ar([1,1.25] * 840, 0, 0.1) };

// filtering: the first argument is the previous bus content. more args can be used as usual.
a[3] = \filter -> { arg in; in * SinOsc.ar(Rand(100,1000)) };
