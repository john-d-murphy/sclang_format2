// Source: Guides/GUI-Layout-Management.schelp block 5
(
w = Window.new(bounds:Rect(100,100,300,300)).layout_(
	VLayout(
		TextField().string_("Super").minHeight_(80),
		TextField().string_("Collider").maxWidth_(150)
	)
).front;
)
