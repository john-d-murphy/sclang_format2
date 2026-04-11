// Source: Classes/Slider2D.schelp block 2
(
s.waitForBoot({
	a = {arg mod = 0.05, index = 0.05;
			var r,out, out2;
			r = Saw.ar(8, 0.03);
			out = PMOsc.ar(
				440,
				660 * mod, 3 * index, 0,
				Lag.ar(r,0.01,1));
			[out,Delay1.ar(out)];
	}.play;

	w = Window("Slider2D", Rect(100,Window.screenBounds.height - 400, 300, 300));
	w.view.decorator = FlowLayout(w.view.bounds);
	t = Slider2D(w, Rect(0, 0,292, 292))
			.y_(0.05)
			.x_(0.05)
			.background_(Color.rand)
			.knobColor_(Color.rand)
			.action_({|sl|
				a.set(\mod,sl.x,\index,sl.y);
			});
	w.front;
	CmdPeriod.doOnce({w.close});
})
)
