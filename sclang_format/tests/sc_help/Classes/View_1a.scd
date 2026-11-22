// Source: Classes/View.schelp block 1 (part 1/20)
(
	~alpha = 1.0;
	~image = Image.new(SCDoc.helpSourceDir +/+ "images/Swamp.png");
	~bounds = Rect(20, 3, 40, 40);
	~window = Window.new("Image background");
	~window.view.background_(Color.gray);
	~window.view.setBackgroundImage(~image, 5, ~alpha, ~bounds);
	~window.front;
)
