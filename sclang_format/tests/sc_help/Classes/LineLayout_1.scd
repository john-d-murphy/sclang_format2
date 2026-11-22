// Source: Classes/LineLayout.schelp block 1
(
w = Window.new;
w.layout = VLayout(
	TextView().string_("Foo\nBar\nFoo\nBar\nFoo"),
	HLayout(
		Button().states_([["Foo"]]),
		[TextField().string_("Bar"), stretch: 1],
		[TextField().string_("BarBarBar"), stretch: 4]
	)
);
w.front;
)
