// Source: Guides/GUI-Layout-Management.schelp block 4
(
w = Window.new(bounds:Rect(100,100,400,80)).layout_(
	HLayout(
		[Button().states_([["Super"]]), stretch:1],
		TextField().string_("Collider")
	)
).front;
)
