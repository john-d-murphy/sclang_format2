// Source: Classes/FileDialog.schelp block 0 (part 4/4)
(
FileDialog({ |path|
	postln("Selected file:" + path);
	postln("File type is:" + File.type(path)) },
	fileMode: 0,
	stripResult: true,
	path: Platform.userAppSupportDir);
)
