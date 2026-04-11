// Source: Classes/Function.schelp block 36
x = { SinOsc.ar(440, 0, 0.3) }.asDefName; // this must complete first
y = Synth(x);
