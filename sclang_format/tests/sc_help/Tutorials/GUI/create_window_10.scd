// Source: Tutorials/GUI/create_window.schelp block 10
(
var window = Window();

View.globalKeyDownAction = FunctionList();

View.globalKeyDownAction.addFunc({ |view, char, mod, unicode, keycode, key|

	switch(keycode)
	// if the keycode is 65307, i.e. ESC, close the window
	{ 65307 } { window.close; };
});

window.front;
)
