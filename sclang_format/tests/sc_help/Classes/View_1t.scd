// Source: Classes/View.schelp block 1 (part 20/20)
(
	~image = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
	~window = Window.new("Image background");
	~slider = Slider2D.new(~window, Rect(10, 10, 200, 200))
		.setBackgroundImage(~image, 5, 1, Rect(0, 0, 100, 100));
	~window.front;
)
