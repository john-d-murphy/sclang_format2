// Source: Guides/Internal-Snooping.schelp block 3 (part 4/5)
(
// change background colors of all open windows
Window.allWindows.do { | window |
	window.view.background = Color.new(0.5 + 0.5.rand, 0.5 + 0.5.rand, 0.5 + 0.5.rand);
}
)
