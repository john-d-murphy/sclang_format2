// Source: Classes/ScrollView.schelp block 2
(
var drawFunc;
w = Window.new;

a = ScrollView(w, Rect(40, 40, 300, 300));
b = ScrollView(w, Rect(0, 40, 40, 300)).hasHorizontalScroller_(false).hasVerticalScroller_(false);
c = ScrollView(w, Rect(40, 0, 300, 40)).hasHorizontalScroller_(false).hasVerticalScroller_(false);
b.background = Color.grey;
c.background = Color.grey;

d = UserView(a, Rect(0, 0, 620, 620));
e = UserView(b, Rect(0, 0, 40, 630));
f = UserView(c, Rect(0, 0, 630, 40));

a.action = { var origin;
	origin = a.visibleOrigin;
	b.visibleOrigin = 0@(origin.y);
	c.visibleOrigin = (origin.x)@0;
};

drawFunc = {
	30.do({arg i;
		(i+1).asString.drawAtPoint((i+1 * 20)@0, Font("Courier", 9), Color.black);
	});
};

d.drawFunc = {
	Pen.use({
		Pen.translate(0, 5);
		drawFunc.value;
	});
	Pen.translate(15, 0).rotate(0.5pi);
	drawFunc.value;
};

e.drawFunc = {
	Pen.translate(40, 0).rotate(0.5pi);
	drawFunc.value;
};

f.drawFunc = {
	Pen.translate(0, 25);
	drawFunc.value;
};

w.front;
)
