// Source: Guides/UserFAQ.schelp block 17 (part 1/2)
var mic = In.ar(8, 1),
    amplitude = Amplitude.kr(mic),
    trig = amplitude > 0.2,
    timer = Timer.kr(trig), // how long since the last trigger?
    filteredTrig = (timer > 0.25) * trig;
