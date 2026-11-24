// Source: Classes/Pdef.schelp block 7 (part 13/24)
(
var quant = #[8, 0, 0, 1]; // quantise to 8 beats, no phase, insert quant to 1 beat
Pdef(\x).quant_(quant);
Pdef(\x).play;
Routine { loop { 8.do { |i| ("uhr:"+i).postln; 1.wait } } }.play(quant: quant);
Pbind(\degree, Pseq((0..7), inf)).play(quant: quant);
)
