// Source: Classes/RangeSlider.schelp block 3
(
s.waitForBoot({
    a={arg freq=1800, bw=0.2;
            var r;
            BBandPass.ar(WhiteNoise.ar(0.3), freq, bw);

            }.play;

    w = Window("2DSlider", Rect(100,Window.screenBounds.height-400, 400 ,50));
    t = RangeSlider(w, Rect(10, 10, 380, 30))
            .lo_(0.4)
            .hi_(0.6)
            .action_({|sl|
                a.set(\freq,1800*(sl.lo+sl.lo)+10,\bw, (sl.hi-sl.lo).abs+0.01);
            });
    t.doAction;

    w.front;
    CmdPeriod.doOnce({w.close});
})
)
