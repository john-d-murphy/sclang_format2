// Source: Classes/UserView.schelp block 6 (part 1/4)
(
var width = 400, height = 400, mx = 0, my = 0, pt, r;

w = Window("animation and mouse interaction", Rect(100, 200, width, height), false);

u = UserView(w, Rect(0, 0, width, height));
u.background = Color.black;
u.animate = true; //animate this view

// allocate data in advance, for optimization:
pt = Point();
r = Rect();

u.drawFunc = {
	Pen.fillColor = Color.green;
	Pen.stringAtPoint(u.frameRate.asString, Point(10, 10)); // display frame rate
	Pen.stringAtPoint(u.frame.asString, Point(10, 30)); // display frame counter
	Pen.color = Color.white;
	pt.x=mx;
	pt.y=my;
	100.do{|i|
		Pen.moveTo(pt);
		pt.x = sin(u.frame*0.04.neg+i)*(5*i)+mx; //use .frame to drive animation
		pt.y = cos(u.frame*0.05+i)*(5*i)+my;
		r.left=pt.x;
		r.top=pt.y;
		r.width=i;
		r.height=i;
		Pen.lineTo(pt);
		Pen.fillStroke;
		Pen.addOval(r);
		Pen.fillStroke;
	};
};
u.mouseDownAction = {|v, x, y|
	mx = x;
	my = y;
};
u.mouseMoveAction = u.mouseDownAction;
w.front;
)
