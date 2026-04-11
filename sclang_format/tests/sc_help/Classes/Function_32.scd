// Source: Classes/Function.schelp block 32
(
var synth = { Out.ar(99, SinOsc.ar([300, 700])) }.play;
{ In.ar(99, 2) }.plot(0.02, synth);
)
