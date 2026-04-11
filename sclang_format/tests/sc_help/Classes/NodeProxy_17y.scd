// Source: Classes/NodeProxy.schelp block 17 (part 25/70)
a.source = { arg f=400; RLPF.ar(Pulse.ar(f * [1,1.02] * 0.05, 0.5, 0.2), f * 0.58, 0.2) };

// control lags
a.lag(\f, 0.5);
