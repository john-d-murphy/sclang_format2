// Source: Classes/ScopeView.schelp block 0 (part 3/6)
(
// listening to the bus, using ScopeOut2 to write it to the buffer
a = SynthDef("monoscope", { |bus, bufnum|
    var z;
    z = In.ar(bus, 2);

    ScopeOut2.ar(z, bufnum);
    Out.ar(0, z);
}).play(
    target: RootNode(s),
    args: [\bus, b.index, \bufnum, f.bufnum],
    addAction: \addToTail // make sure it goes after what you are scoping
);

// making noise onto the buffer
d = SynthDef("noise", { |bus|
    var z;
    z = LFSaw.ar(SinOsc.kr(0.1).range(300, 1000), [0, 1]*pi) * 0.1;
    Out.ar(bus, z);
}).play(
    s,
    [\bus, b.index]
);
c.start; // Tell the ScopeView to start
CmdPeriod.doOnce({ w.close });
)
