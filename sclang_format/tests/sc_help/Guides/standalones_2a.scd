// Source: Guides/standalones.schelp block 2 (part 1/9)
(
// 4. write a class extension file to look for the startupFile
// in the app, in Platform.resourceDir for self-containment.
~overDir = ~newAppResDir +/+ "SCClassLibrary/SystemOverwrites";
File.mkdir(~overDir);
~writeText.value(~overDir +/+ "extModStartupFile.sc",
	"+ OSXPlatform {
	startupFiles {
		^[Platform.resourceDir +/+ \"startup.scd\"];
	}
}
"
);
~overDir.openOS;
)
