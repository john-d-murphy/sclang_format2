// Source: Classes/String.schelp block 71 (part 1/2)
(
File.use(Platform.defaultTempDir +/+ "loadPaths_example.scd", "w", { |file|
	file << "\"This text is the result of a postln command which was loaded and executed by loadPaths\".postln;";
	file <<	"\"I will now throw a dice for you: \".post; 7.rand;"
})
)
