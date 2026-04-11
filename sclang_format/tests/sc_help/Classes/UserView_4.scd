// Source: Classes/UserView.schelp block 4
(
var func, views;

func = {|me|
	Pen.use{
		1.do{
			Color(
				rrand(0.0, 1),
				rrand(0.0,0.2),
				rrand(0.0, 0.8),
				rrand(0.4, 0.8)
			).set;
			Pen.addArc((400.exprand(2))@(100.rand), rrand(10, 50), 2pi.rand, pi);
			Pen.perform([\stroke, \fill].choose);
		}
	}
};

w = Window.new("DrawFunc Examples").front;
w.view.background_(Color.white);
views = {|i|
	v = UserView(w, Rect(20+(i*120), 100, 100, 100));
	v.background = Color.rand;
	v.drawFunc = func;
	v.mouseMoveAction = {|me| me.refresh };
	v.clearOnRefresh_(false);
} ! 3;
w.refresh;
)
