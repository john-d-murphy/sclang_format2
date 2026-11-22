// Source: Guides/Backwards-Compatibility.schelp block 2 (part 1/10)
x = { arg freq = 440; Out.ar(1, SinOsc.ar(freq, 0, 0.5)) }.play(fadeTime: 0);
