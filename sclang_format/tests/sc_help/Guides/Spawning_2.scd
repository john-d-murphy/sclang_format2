// Source: Guides/Spawning.schelp block 2
(
var w, r;

w = Window.new("trem", Rect(512, 256, 360, 130));
w.front;

r = Routine({ arg time;
	60.do({ arg i;
		0.05.yield; // wait for 0.05 seconds
		{
			w.bounds = w.bounds.moveBy(10.rand2, 10.rand2);
			w.alpha = cos(i*0.1pi)*0.5+0.5;
		}.defer;
	});
	1.yield; // wait for 1 second before closing w
	w.close;
});

SystemClock.play(r);
)
