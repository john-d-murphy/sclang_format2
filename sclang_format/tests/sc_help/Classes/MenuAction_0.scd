// Source: Classes/MenuAction.schelp block 0
(
~view = View().layout_(HLayout(
	Button()
		.states_([["Options..."]])
		.action_({ ~menu.front })
));
~menu = Menu(
	MenuAction("enabled")
		.checkable_(true)
		.action_({
			|a, enabled|
			if (enabled) {
				"Enabled".postln;
				~view.background = Color.green(1, 0.5);
			} {
				"Disabled".postln;
				~view.background = Color.clear;
			}
		})
);
~view.front;
)
