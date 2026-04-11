// Source: Classes/CompositeView.schelp block 1
( //Click on the different views and hit keys on the keyboard.

w = Window.new;

c = CompositeView(w, Rect(0, 0, 200, 200)).background_(Color.grey.alpha_(0.3));

a = Slider2D(c,Rect(0, 0, 100, 100)).background_(Color.rand);
b = Slider2D(c,Rect(100, 100, 100, 100)).background_(Color.rand);

w.front;

c.keyDownAction = {
	"keydown bubbled up to c".postln;
};

// d is on window w, not on composite view c
d = Slider2D(w,Rect(200, 200, 100, 100));
d.background = Color.black;
)
