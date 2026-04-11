// Source: Classes/Image.schelp block 22
(
	i = Image.new(
		// "http://supercollider.sourceforge.net/theme/sc01/icon.supercollider.gif"
		SCDoc.helpSourceDir +/+ "images/icon.supercollider.png"
	);

	w = Window.new("Image", Rect(120, 400, 360, 180)).front;
	w.onClose_({ i.free }); // free the image when the window is closed
	w.drawHook_({
		i.drawInRect(Rect(10,10,50,50), Rect(10,10,50,50), 2, 1.0); // only a section
	});
)
