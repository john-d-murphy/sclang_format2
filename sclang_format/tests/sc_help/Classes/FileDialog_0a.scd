// Source: Classes/FileDialog.schelp block 0 (part 1/4)
(
FileDialog({ |paths|
	postln("Selected path:" + paths[0]);
	}, {
	postln("Dialog was cancelled. Try again.");
	});
)
