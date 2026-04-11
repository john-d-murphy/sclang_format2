// Source: Classes/View.schelp block 0
(
	~bounds = Rect(10, 10, 150, 18);
	~image = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
	~window = Window.new("Image background");
	~slider = Slider.new(~window, ~bounds)
		.backgroundImage_(~image);
	~window.front;
	~image.free;
)
