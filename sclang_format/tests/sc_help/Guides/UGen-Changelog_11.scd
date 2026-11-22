// Source: Guides/UGen-Changelog.schelp block 11
{ Phasor.ar(1, 1, start: 0, end: 10, resetPos: 5) }.loadToFloatArray(1e-4, action: _.postln)
