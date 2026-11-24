// Source: Classes/EZSlider.schelp block 1 (part 3/7)
(
w = Window.new.front;
w.view.decorator = FlowLayout(w.view.bounds);
w.view.decorator.gap = 2@2;

20.do{
	EZSlider(w, 392@16, " Freq ", \freq, unitWidth: 30, initVal: 6000.rand, numberWidth: 60, layout: \horz)
	.setColors(Color.grey, Color.white)
	.font_(Font("Helvetica", 11));

};
);
