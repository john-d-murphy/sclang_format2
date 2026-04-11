// Source: Guides/standalones.schelp block 2 (part 9/9)
(
// use the internal extensions - repeat this when you move the app!
LanguageConfig.addIncludePath(Platform.resourceDir +/+ "InternalExtensions");
// exclude the default
LanguageConfig.addExcludePath(Platform.userExtensionDir);
LanguageConfig.addExcludePath(Platform.systemExtensionDir);
LanguageConfig.store;

// see if the internal path was stored OK:
LanguageConfig.includePaths.last;
// this should not be empty:
LanguageConfig.includePaths.last.pathMatch.postln;
)
