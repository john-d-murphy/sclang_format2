// Source: Classes/NumberBox.schelp block 1
(
s.waitForBoot({

    n={arg freq=220;
        var out;
        out=SinOsc.ar(freq,0,0.2);
        8.do{out = AllpassN.ar(out, 0.2,0.02+0.20.rand,8)};
        out;
    }.play;

    w = Window("Use arrow keys to change the frequency by steps", Rect(100, 500, 500, 120));
    b = NumberBox(w, Rect(200, 10, 100, 20));
    b.value = 220;
    b.action = {arg numb; n.set(\freq,numb.value); };
    b.step=55; //make the step a fraction of the freq
    b.focus;
    w.front;

    CmdPeriod.doOnce({w.close});

});
)
