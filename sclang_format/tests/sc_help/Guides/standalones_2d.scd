// Source: Guides/standalones.schelp block 2 (part 4/9)
(
~projDirName = ~newAppName ++ "_files";
~projDir = ~newAppResDir +/+ ~projDirName;
File.mkdir(~projDir);
~projDir.openOS;

~loadFileCode =
"\"*** startup file for % loading.\".postln;
\"*** My Platform.userAppSupportDir is: \".postln;
Platform.userAppSupportDir.postcs;
thisProcess.nowExecutingPath.openOS;

// configure server options here if needed:
s.options.memSize = 8192 * 16;
// move server port away from default (57110)
// to avoid interference/clashes with SuperCollider itself:
s.addr.port = 57105;

s.waitForBoot {
	\"*** server booted, plays ping.\".postln;
	Env.perc.test;

	\"*** loading files next ? \".postln;
	// put your loading sequence here:
	// \"loadX.scd\".loadRelative;
	// s.sync; // e.g. when loading buffers
 	// 1.wait;
 	// \"loadY.scd\".loadRelative;
};"
.format(~newAppName);

~loadfilepath = ~projDir +/+ "00_loadMe.scd";
~writeText.value(~loadfilepath, ~loadFileCode);
~loadfilepath.openOS;


// write a startupFile that points to the load file:
~startupCode =
"// example startup file for osx standalone.
// running loadfile in this project folder:
%.loadRelative;
".format((~projDirName +/+ ~loadfilepath.basename).cs);

~writeText.(~newAppResDir +/+ "startup.scd", ~startupCode);
(~newAppResDir +/+ "startup.scd").openOS;
)
