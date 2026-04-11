// Source: Guides/GUI-Introduction.schelp block 6
(
w = Window.new("GUI Introduction",Rect(200,200,200,70)).front;
a = [Font.defaultMonoFace, Font.defaultSansFace, Font.defaultSerifFace];
b = Button.new(w,Rect(10,10,180,50))
	.states_([["Monospace"],["Sans serif"],["Serif"]])
	.font_(a[0])
	.action_({|b| b.font = a[b.value]});
)
