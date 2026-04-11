// Source: Guides/GUI-Layout-Management.schelp block 6
(
w = Window.new(bounds:Rect(100,100,200,200)).layout_(
	VLayout(
		UserView.new.background_(Color.rand),
		TextField().string_("Super").maxWidth_(100),
		UserView.new.background_(Color.rand).minSize_(200@200),
		TextField().string_("Collider").maxWidth_(100)
	)
).front;
)
