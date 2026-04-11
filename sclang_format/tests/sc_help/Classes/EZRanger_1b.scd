// Source: Classes/EZRanger.schelp block 1 (part 2/7)
(
w=Window.new.front;
w.view.decorator=FlowLayout(w.view.bounds);
w.view.decorator.gap=1@1;

20.do{
	g=EZRanger(w, 400@16," test  ", \freq,{|v| v.value.postln},[50.rand,50+20000.rand],unitWidth:30)
	.setColors(Color.grey,Color.white, Color.grey(0.7),Color.grey,Color.white, Color.white, Color.yellow)
	.font_(Font("Helvetica",11));

};
);
