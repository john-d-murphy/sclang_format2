// Source: Classes/ToolBar.schelp block 0
(
View().fixedWidth_(300).layout_(HLayout(
	ToolBar(
		MenuAction("Option A", { "Option A".postln }),
		MenuAction("Option B", { "Option B".postln }),
		MenuAction("Option C", { "Option C".postln })
	)
)).front
)
