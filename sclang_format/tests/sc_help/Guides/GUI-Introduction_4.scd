// Source: Guides/GUI-Introduction.schelp block 4
(
w = Window("GUI Introduction").background_(Color.rand).front;
b = Button(w, Rect(10,10,100,30)).states_([
	["One",Color.rand,Color.rand],
	["Two",Color.rand,Color.rand],
	["Three",Color.rand,Color.rand]
]);
l = ListView.new(w, Rect(10,50,200,100))
	.items_(["One","Two","Three"])
	.colors_([Color.rand,Color.rand,Color.rand])
	.hiliteColor_(Color.blue)
	.selectedStringColor_(Color.white);
r = Slider(w, Rect(10, 160, 200, 20))
	.knobColor_(Color.rand)
	.background_(Color.rand);
)
