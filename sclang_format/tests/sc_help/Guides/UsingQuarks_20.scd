// Source: Guides/UsingQuarks.schelp block 20
(
  name: "DemonWidgets",
  // ...
  preInstall: {|data|
	File.mkdir("~/samples/%".format(data[\name]));
  },
  postUninstall: {
	"Samples at '~/samples/DomenWidgets' must be deleted manually".warn;
  },
)
