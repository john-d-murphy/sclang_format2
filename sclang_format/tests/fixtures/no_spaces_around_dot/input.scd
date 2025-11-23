(
SynthDef(\test, { |freq=440|
    // message sends with ugly spacing
    var sig;
    sig = SinOsc.ar(freq .linexp(0, 1, 200, 2000)) * 0.1;
    sig = sig .clip(-0.5, 0.5);
    sig = sig  .  tanh;

    // chained sends
    "hello" .toUpper .reverse .postln;

    // range and numbers that should NOT turn into floats
    var r = 0 .. 10;
    var w = 1 . 5;

    // strings/comments with dots should be untouched
    "foo . bar".postln;   // foo . bar
    // comment: foo . bar
    /* block foo . bar */
});
)
