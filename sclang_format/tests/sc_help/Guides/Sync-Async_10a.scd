// Source: Guides/Sync-Async.schelp block 10 (part 1/5)
(
SynthDef("help-SendTrig",{
    SendTrig.kr(Dust.kr(1.0), 0, 0.9);
}).send(s);

// register to receive this message
a = OSCFunc({ arg msg, time;
    ("This is the done message for the SynthDef.send:" + [time, msg]).postln;
}, '/done').oneShot; // remove me automatically when done

b = OSCFunc({ arg msg, time;
    [time, msg].postln;
}, '/tr');
c = OSCFunc({ arg msg;
    "this is another call".postln;
}, '/tr');
)
