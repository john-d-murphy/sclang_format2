// Source: Classes/EZNumber.schelp block 1 (part 2/4)
(
w=Window.new.front;
w.view.decorator=FlowLayout(w.view.bounds);
w.view.decorator.gap=2@2;

40.do{
		g=EZNumber(w, 170@16," test  ", \freq,unitWidth:30, numberWidth:60,layout:\horz);
		g.setColors(Color.grey,Color.white, Color.grey(0.8));
};
);
