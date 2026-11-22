// Source: Classes/UserView.schelp block 3
(
var drawFunc, mouseDownFunc, mouseUpFunc, mouseMoveFunc, sat = 0, startX;

drawFunc = { |me|
	Pen.use{
		10.do{
			Color.red(rrand(0.0, 1), rrand(0.3, 0.8)).set;
			Pen.addArc((400.exprand(2))@(100.rand), rrand(10, 50), 2pi.rand, pi);
			Pen.perform([\stroke, \fill].choose);
		}
	}
};

mouseDownFunc = { |me, x, y, mod|
	startX = x;
	postf("begin path: x=% realtive mouse coordinates:%\n", startX, x@y);
};

mouseUpFunc = { |me, x, y, mod|
	postf("end path: (startX-x)==% mouse coordinates:%\n", (startX-x), x@y);
};

mouseMoveFunc = { |me, x, y, mod|
	sat = ((startX-x)/100);
	(x@y).postln;
	me.refresh;
};

w = Window.new.front;
w.view.background_(Color.white);
3.do{ |i|
	v = UserView(w, Rect(20+(i*120), 100, 100, 100));
	v.background_(Color.rand);
	v.drawFunc = drawFunc;
	v.mouseDownAction = mouseDownFunc;
	v.mouseUpAction = mouseUpFunc;
	v.mouseMoveAction = mouseMoveFunc;
};
w.refresh;
)
