// Source: Classes/UGen.schelp block 3 (part 2/2)
(
{
    var freqs = SinOsc.ar([0.2, 0.3]).range(420, 460);
    freqs.poll(label: [\freq1, \freq2]);
    SinOsc.ar(freqs, 0, 0.2);
}.play;
)
