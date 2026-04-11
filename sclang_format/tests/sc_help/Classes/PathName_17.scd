// Source: Classes/PathName.schelp block 17
(
FileDialog.new(
	{ arg ok, path;
	var myPathName;
	if (ok,
		{
			myPathName = PathName.new(path);

			"New PathName object:  ".postc;
			myPathName.postln;

			"fileName only:        ".postc;
			myPathName.fileName.postln;

			"path up to file only: ".postc;
			myPathName.pathOnly.postln;

			"folder Name:          ".postc;
			myPathName.folderName.postln;
		}
	)
	}
)
)
