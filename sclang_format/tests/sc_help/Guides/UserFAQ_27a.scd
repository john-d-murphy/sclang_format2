// Source: Guides/UserFAQ.schelp block 27 (part 1/3)
(
a = {
    var trig = Dust.kr(8),
    decay = Decay2.kr(trig, 0.01, 0.1),
    sig = SinOsc.ar(TExpRand.kr(200, 600, trig), 0, 0.1) * decay;
    SendReply.kr(trig, '/bleep', trig);
    sig ! 2
}.play;

o = OSCdef(\bleepResponder, { |msg|
    msg.postln;
}, '/bleep', s.addr, argTemplate: [a.nodeID]);
)
