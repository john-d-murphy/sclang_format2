// Source: Classes/UserView.schelp block 2
(
var w, r, u;
var clicked, relativeWhere;
r = { Rect(300.rand, 300.rand, 110, 110) } ! 4;

w = Window.new.front;
u = UserView(w, Rect(0, 0, 400, 400));
u.drawFunc = {
	r.do { |x, i|
		Pen.addOval(x); // wie addRect
		Pen.color = Color.hsv(0.9 * (1/(i+1)), 0.6, 1);
		Pen.draw;
	};
};
u.mouseDownAction = { |v, x, y|
	r.do { |rect, i|
		if(rect.contains(Point(x, y))) {
			clicked = i;
			relativeWhere = Point(x, y) - rect.origin;
		};
	};
};

u.mouseMoveAction = { |v, x, y|
	var rect;
	if(clicked.notNil) {
		rect = r.at(clicked);
		r.put(clicked, rect.origin = Point(x, y) - relativeWhere);
		w.refresh;
	}
};

u.mouseUpAction = {
	clicked = nil;
}
)
