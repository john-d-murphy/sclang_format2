// Source: Classes/MainMenu.schelp block 0
(
~show = MenuAction("Show Window", {
	~window ?? {
		~window = TextView().string_("Here it goes!").minSize_(300@200);
		~window.onClose = { ~window = nil };
		~window.front;
	}
});
~hide = MenuAction("Hide Window", {
	~window !? {
		~window.close();
		~window = nil;
	}
});

MainMenu.register(Menu(~show, ~hide).title_("My Quark"), "Quarks", "My Quark")
)
