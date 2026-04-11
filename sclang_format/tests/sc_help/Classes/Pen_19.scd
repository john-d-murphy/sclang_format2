// Source: Classes/Pen.schelp block 19
(
w = Window.new.front;
w.view.background = Color.red;
i = Image.open(SCDoc.helpSourceDir +/+ "images/Swamp.png");
w.drawFunc_({
	Pen.drawImage( Point(140, 140), i, operation: 'sourceOver', opacity:1);
});
)
