// Source: Classes/Routine.schelp block 14
(
var update, w, b;
w = Window.new("State Window", Rect(150, Window.screenBounds.height - 140, 380, 60));

// a convenient way to set the button label
update = {
	|but, string| but.states = [[string.asString, Color.black, Color.red]];
	but.refresh;
};

b = Button(w, Rect(10, 10, 360, 40));
b.font_(Font("Impact", 24));

update.value(b, "there is only one state");

// if an action should do something different each time it is called, a routine is the
// right thing to use. This is better than creating variables outside and setting them
// from the action function to keep state from one action to the next

b.action_(Routine { |butt|
	rrand(15, 45).do { |i|
		update.value(butt, "%. there is still only 1 state".format(i + 2));
		0.yield; // stop here
	};
	w.close;
});

w.front;
)
