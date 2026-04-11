// Source: Guides/UserFAQ.schelp block 10
SynthDef(\kablooie, { |x = 0|
    var signal;
    if(x > 0) {
        signal = SinOsc.ar
    } {
        signal = Saw.ar
    };
});
