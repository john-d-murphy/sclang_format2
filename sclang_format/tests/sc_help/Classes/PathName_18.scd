// Source: Classes/PathName.schelp block 18
(
FileDialog.new(
	{ arg ok, path;
	var myPathName, myFile;
	if (ok,
		{
			myPathName = PathName.new(path);

			// read your file from disk, e.g. a soundFile/

			myFile = SoundFile.new;
			if (myFile.openRead(path),
				{
					Library.put(
						[ myPathName.folderName.asSymbol, myPathName.fileName.asSymbol ],
						myFile);
					("Check Library.global" + myPathName.folderName + "please.").postln;
				},
				{ ("Could not read soundfile" + path ++ ".").postln; }
			);
			myFile.close;
		}
	)
	}
)
)
