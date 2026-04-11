// Source: Classes/Ndef.schelp block 12 (part 8/24)
(
Pdef(\ppar,
    Ppar({ |i|
        Pbind(
            \instrument, \grain,
            // we only set a single channel
            \dur, ~durs[i],
            \freq, ~freqs.subBus(i).asMap,
            \amp, ~amps.subBus(i).asMap,
            // the Pattern will play to a yet unknown private bus
            // we only want to make sure the offset is right
            \channelOffset, i,
        )
    }!~numChans)
)
)
