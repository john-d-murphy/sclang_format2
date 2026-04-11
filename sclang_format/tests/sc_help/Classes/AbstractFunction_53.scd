// Source: Classes/AbstractFunction.schelp block 53
(
var f, g, product;
f = { SinOsc.ar(400) };
g = { LFPulse.kr(8)  };
product = f * g * 0.1;
{ Pan2.ar(product, SinOsc.kr(0.3)) }.play;
)
