// Source: Guides/GUI-Introduction.schelp block 5
(
x = QPalette.auto(Color.red(0.8), Color.red(0.5));
y = QPalette.auto(Color.cyan(1.4), Color.cyan(1.8));
p = QtGUI.palette;
QtGUI.palette = x;
w = Window.new("GUI Introduction").front;
w.onClose = {QtGUI.palette = p};
Button.new(w, Rect(10,10,100,30)).states_([
	["Red", Color.black, Color.grey(0.7)],
	["Cyan"]
]).action_({ |b| QtGUI.palette = if(b.value == 0){x}{y} });
ListView.new(w, Rect(10,50,200,100))
	.items_(["One","Two","Three"])
	.colors_([Color.grey(0.4),Color.grey(0.5),Color.grey(0.6)]);
Slider(w, Rect(10, 160, 200, 20));
RangeSlider(w, Rect(10, 190, 200, 20));
)
