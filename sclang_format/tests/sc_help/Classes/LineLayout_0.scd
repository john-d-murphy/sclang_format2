// Source: Classes/LineLayout.schelp block 0
(
w = Window.new;
w.layout = VLayout(
	[Button().states_([["Foo"]]), stretch: 1, align: \bottomLeft],
	20,
	[TextView().string_("Bar\nBar\nBar\n"), s: 3],
	[nil, s: 1]
);
w.front;
)
