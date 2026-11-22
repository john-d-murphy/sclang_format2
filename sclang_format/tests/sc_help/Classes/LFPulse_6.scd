// Source: Classes/LFPulse.schelp block 6
(
{
    [
        Pulse.ar(100, 0.3, 0.5),
        LFPulse.ar(100, 0, 0.3, 0.5)
    ] * 0.2
}.scope(bufsize: 44100, zoom: 5)
)
