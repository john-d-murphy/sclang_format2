// Source: Classes/EZKnob.schelp block 1 (part 1/20)
(	// basic use
	w = Window.new.front;
	g = EZKnob(w, 50@90, " test  ", \freq, { |a| a.value.postln });
	g.setColors(Color.grey, Color.white);
);
