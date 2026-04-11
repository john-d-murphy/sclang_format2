// Source: Guides/GUI-Introduction.schelp block 3
w = Window.new("GUI Introduction").layout_(
	VLayout(
		HLayout( Button(), TextField(), Button() ),
		TextView()
	)
).front;
