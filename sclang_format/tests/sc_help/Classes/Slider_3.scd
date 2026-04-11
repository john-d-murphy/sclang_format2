// Source: Classes/Slider.schelp block 3
( // select the slider, type something and watch the post window
w = Window.new;
c = Slider(w, Rect(0,0,100,30));
c.keyDownAction = { |view, char, modifiers, unicode, keycode|
	[char, modifiers, unicode, keycode].postln
};
w.front;
)
