// Source: Classes/MenuAction.schelp block 1
(
~view = View(bounds: 300@100).layout_(VLayout(
	Button()
		.states_([["Options..."]])
		.action_({ ~menu.front }),
	~text = TextView()
));

~menu = Menu (
	MenuAction("Option A").toolTip_("I like option A..."),
	MenuAction("Option B").toolTip_("But option B is better..."),
	MenuAction("Option C").toolTip_("No one really likes C."),
);

~actionFunc = {
	|obj, what, action|
	if (what == \hovered) {
		~text.string = action.toolTip
	};
	if (what == \aboutToHide) {
		~text.string = ""
	}
};
~menu.addDependant(~actionFunc);
~view.onClose_({ ~menu.removeDependant(~actionFunc) }).front;

)
