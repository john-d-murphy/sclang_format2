// Source: Tutorials/GUI/create_window.schelp block 9
(
var window = Window();
var fullScreenActive = false;

View.globalKeyDownAction = { |view, char, mod, unicode, keycode, key|

	switch(keycode)

	// if the keycode is 65307 (ESC): close the window
	{ 65307 } { window.close; }

	// if the keycode is 102 (f): toggle full screen ON / OFF
	{ 102 } {
		fullScreenActive = fullScreenActive.not;
		if(fullScreenActive)
		{ window.fullScreen; }
		{ window.endFullScreen; };
	};
};

window.front;
)
