// Source: Classes/UserView.schelp block 7 (part 2/3)
( //replace the drawFunc above while running
u.drawFunc = {
	Pen.fillColor = Color.red;
	Pen.fillOval(Rect(200, 200, sin(u.frame*0.031)*200, sin(u.frame*0.044)*200));
	Pen.fillOval(Rect(200, 200, sin(u.frame*0.052)*200, sin(u.frame*0.065)*200));
	Pen.fillOval(Rect(200, 200, sin(u.frame*0.073)*200, sin(u.frame*0.086)*200));
}
)
