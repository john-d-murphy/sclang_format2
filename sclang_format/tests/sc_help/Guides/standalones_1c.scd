// Source: Guides/standalones.schelp block 1 (part 3/5)
(
// 2. fixups in the new app:
// a. fix the Info.plist file by replacing the name:
~infoPlistPath = ~pathToNewApp +/+ "Contents/Info.plist";
// get its string, replace the SC names, write again
~infoString = ~readText.(~infoPlistPath);
~executableIndex = ~infoString.find("<key>CFBundleExecutable</key>");
~nameToReplace = ~infoString.copyRange(
	~infoString.find("<string>", offset: ~executableIndex) + 8,
	~infoString.find("</string>", offset: ~executableIndex) - 1
);

"replacing bundleName % in plist file at these locations: "
.postf(~nameToReplace.cs);
~foundNameLocs = ~infoString.findAll(~nameToReplace).postln;

~newInfoString = ~infoString.replace(~nameToReplace, ~newAppName );
~writeText.(~infoPlistPath, ~newInfoString);
// ~readText.(~infoPlistPath);

// b. rename the binary file:
"renaming macos binary to: ".post;
// fixups in the new app - 2. rename the binary inside the app folder
unixCmd("mv -i"
	+ quote(~pathToNewApp +/+ "Contents/MacOS/" +/+ ~nameToReplace)
	+ quote(~pathToNewApp +/+ "Contents/MacOS/" ++ ~newAppName).postln
);
);
