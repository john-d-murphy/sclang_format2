// Source: Classes/DrawGrid.schelp block 2
(
w = Window.new.front;
u = UserView(w,w.bounds.size.asRect);

// The spec defines its preferred grid system
x = \lofreq.asSpec.grid; // x grid lines
y = \amp.asSpec.grid;    // y grid lines
i = 40;                  // grid inset

d = DrawGrid(u.bounds.size.asRect.insetBy(i), x, y);

u.drawFunc = { d.draw };
u.resize_(5);
u.onResize = { |u|
	d.bounds = u.bounds.size.asRect.insetBy(i)
};
)
