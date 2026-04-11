// Source: Classes/EZText.schelp block 1 (part 2/6)
(
w=Window.new.front;
w.view.decorator=FlowLayout(w.view.bounds);
w.view.decorator.gap=2@2;

40.do{
		g=EZText(w, 170@16," test  ", textWidth: 120,layout:\horz);
		g.setColors(Color.grey, Color.white, Color.grey(0.8));
};
);
