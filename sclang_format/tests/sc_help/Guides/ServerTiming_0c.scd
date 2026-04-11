// Source: Guides/ServerTiming.schelp block 0 (part 3/3)
2.do({ |chan|
    var rout;
    rout = Routine({
        var freq;
        {   freq = 0;
            rrand(400, 1000).do({ freq = freq + 1 });
            [thisThread.clock.beats, thisThread.clock.elapsedBeats].postln;
            Synth(\sinGrain, [\out, chan, \freq, freq, \dur, 0.005]);
            0.1.wait;
        }.loop;
    });
    TempoClock.default.schedAbs(TempoClock.default.elapsedBeats.roundUp(1), rout);
});
