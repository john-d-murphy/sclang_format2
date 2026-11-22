// Source: Classes/FileDialog.schelp block 0 (part 2/4)
(
FileDialog({ |path|
	postln("Selected path:" + path);
	}, {
	postln("Dialog was cancelled. Try again.");
	}, stripResult: true);
)
