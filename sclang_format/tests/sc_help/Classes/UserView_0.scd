// Source: Classes/UserView.schelp block 0
(
w=Window.new;
v=UserView(w, w.view.bounds.insetBy(50,50));
v.resize = 5;
v.background_(Color.rand);
v.drawFunc={|uview|
		Pen.moveTo(0@uview.bounds.height.rand);
		Pen.lineTo(uview.bounds.width@uview.bounds.height.rand);
		Pen.stroke;
	};
v.mouseDownAction={v.refresh};
w.front;
)
