// Source: Guides/standalones.schelp block 2 (part 6/9)
(
~newAppQuarksDir = ~newAppResDir +/+ "InternalExtensions";

// copy all folders in my current quarks includePaths
// to Resources/SCClassLibrary to freeze them:
File.mkdir(~newAppQuarksDir);

~pathsToCopy = LanguageConfig.includePaths.reject { |path|
	["SCClassLibrary", "HelpSource"].includesEqual(path.basename)
};

~pathsToCopy.collect(_.basename).sort.printcsAll;

if (~newAppQuarksDir.pathMatch.notEmpty) {
	"/*** copying Quarks : ***/".postln;
	~pathsToCopy.do { |path|
		unixCmd(
			"cd" + quote(~newAppQuarksDir) ++ ";" ++
			" cp -ir" + quote(path).postln + ".");
	};
};
"";
)
