// Source: Classes/FileDialog.schelp block 0 (part 3/4)
(
FileDialog({ |paths|
	postln("Selected paths:");
	paths.do(_.postln);
	}, fileMode: 3);
)
