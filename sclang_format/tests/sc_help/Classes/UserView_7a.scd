// Source: Classes/UserView.schelp block 7 (part 1/3)
(
var width = 400, height = 400, xspeed = 3, yspeed = 2, x = width*0.5, y = height*0.5;
w = Window("ball", Rect(100, 200, width, height));
u = UserView(w, Rect(0, 0, width, height));
u.background = Color.black;
u.animate = true;
u.drawFunc = {
	if(x<0 or:{x>width}, {xspeed = 0-xspeed});
	if(y<0 or:{y>height}, {yspeed = 0-yspeed});
	x = x+xspeed;
	y = y+yspeed;
	Pen.fillColor = Color.white;
	Pen.fillOval(Rect.aboutPoint(Point(x, y), 8, 8));
};
w.front;
)
