// Source: Classes/EZKnob.schelp block 1 (part 2/20)
(
w = Window.new.front;
w.view.decorator = FlowLayout(w.view.bounds);
w.view.decorator.gap = 2@2;

20.do{
	EZKnob(w, 180@24, " Freq ", \freq, unitWidth: 30, initVal: 6000.rand, layout: \horz)
	.setColors(Color.grey, Color.white)
	.font_(Font("Helvetica", 11));

};
);
