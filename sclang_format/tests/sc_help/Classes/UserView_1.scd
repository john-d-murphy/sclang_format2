// Source: Classes/UserView.schelp block 1
(
var func;

func = {|me|
	Pen.use{
		10.do{
			Color.red(rrand(0.0, 1), rrand(0.0, 0.5)).set;
			Pen.addArc((400.exprand(2))@(100.rand), rrand(10, 100), 2pi.rand, pi);
			Pen.perform([\stroke, \fill].choose);
		}
	}
};

w = Window.new("DrawFunc Examples").front;
w.view.background_(Color.white);

3.do{|i|
	v = UserView(w, Rect(20+(i*120), 100, 100, 100))
		.drawFunc_(func);
	v.resize=3; // the func coordinates ar valid even though the view move on resize
	v.background_(Color.rand);
};

w.refresh;
)
