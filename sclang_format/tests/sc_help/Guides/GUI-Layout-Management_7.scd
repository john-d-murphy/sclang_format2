// Source: Guides/GUI-Layout-Management.schelp block 7
(
w = Window.new.layout_(
	HLayout(
		[Button.new.states_([["Super"]]), align:\bottom],
		TextView(),
		[Button.new.states_([["Collider"]]), align:\top]
	)
).front;
)
