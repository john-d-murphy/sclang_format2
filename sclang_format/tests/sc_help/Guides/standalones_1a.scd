// Source: Guides/standalones.schelp block 1 (part 1/5)
(
// define the name for the new app and its location:
~newAppName = "StehAllein";
~newAppLocation = "~/Desktop".standardizePath;

// --- nothing to be changed below this line --- \\
// some helper functions
~readText = { |path| File.readAllString(path); };
~writeText = { |path, string| File(path, "w").write(string).close; };
~copyFolder = { |orig, dest|
	var str = "cp -ir" + quote(orig) + quote(dest);
	str.postcs;
	unixCmd(str);
};

// make some needed paths and folders
~pathToThisApp = Platform.resourceDir.dirname.dirname;
~thisAppName = ~pathToThisApp.basename.splitext.first;
~pathToNewApp = ~newAppLocation +/+ ~newAppName ++ ".app";
~newAppResDir = ~pathToNewApp +/+ "Contents/Resources";
~newAppSupportDir = Platform.userConfigDir.dirname +/+ ~newAppName;
);
