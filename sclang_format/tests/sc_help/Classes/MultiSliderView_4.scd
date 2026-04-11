// Source: Classes/MultiSliderView.schelp block 4
(
var size;
size = 12;
s.waitForBoot({
    n={arg freq=330; SinOsc.ar(freq,0,0.2)}.play;

    w = Window("test", Rect(200 , 450, 10 + (size * 17), 10 + (size * 17)));
    w.view.decorator = FlowLayout(w.view.bounds);
    b = MultiSliderView(w, Rect(0, 0, size * 17, size * 17));
    b.value_( Array.fill(size,{|i| i/size}) );
    b.background_(Color.rand);
    b.action = {arg xb;
        n.set(\freq, 330+(1100*xb.value.at(xb.index)));
        ("index: " ++ xb.index ++" value: " ++ xb.value.at(xb.index)).postln};
    b.elasticMode_(1); // makes the squares fit evenly
    b.showIndex = true; // cursor mode
    b.readOnly=true;
    w.front;

    r = Routine({
        0.1.wait;
        30.do({ arg i;
            b.index_(i%size);

            b.doAction;
            0.1.wait;
        });

        20.do({ arg i;
            b.index_(b.size.rand);
            b.doAction;
            [0.1,0.2].choose.wait;
        });
        1.wait;
        n.free;
        {w.close}.defer;
    });
    AppClock.play(r);
});
)
