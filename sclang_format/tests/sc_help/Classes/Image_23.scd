// Source: Classes/Image.schelp block 23
(
i = Image.new(
	// "http://supercollider.sourceforge.net/theme/sc01/icon.supercollider.gif"
	SCDoc.helpSourceDir +/+ "images/icon.supercollider.png"
);

w = Window.new("Image", Rect(120, 400, 360, 180)).front;
w.onClose_({ i.free }); // free the image when the window is closed
w.drawFunc_({
	i.tileInRect(w.view.bounds, nil, 2, 1.0); // all image contents
});
)
