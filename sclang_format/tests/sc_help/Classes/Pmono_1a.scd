// Source: Classes/Pmono.schelp block 1 (part 1/4)
x = { |freq = 440, amp = 0.6| MoogFF.ar(PinkNoise.ar(amp), freq).dup }.play;
