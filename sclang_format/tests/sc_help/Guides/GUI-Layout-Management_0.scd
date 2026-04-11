// Source: Guides/GUI-Layout-Management.schelp block 0
(
w = Window(bounds:Rect(200,200,200,200)).layout_(
	VLayout(
		TextField(), TextField(), TextField(),
		HLayout( Button(), Button(), Button() )
	)
).front;
)
