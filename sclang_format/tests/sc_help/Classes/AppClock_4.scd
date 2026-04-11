// Source: Classes/AppClock.schelp block 4
(
var w, r;
w = Window.new("trem", Rect(512, 256, 360, 130));
w.front;
r = Routine({ arg appClockTime;
	["AppClock has been playing for secs:",appClockTime].postln;
	60.do({ arg i;
		0.05.yield;
		w.bounds = w.bounds.moveBy(10.rand2, 10.rand2);
		w.alpha = cos(i*0.1pi)*0.5+0.5;
	});
	1.yield;
	w.close;
});
AppClock.play(r);
)
