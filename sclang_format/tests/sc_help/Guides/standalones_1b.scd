// Source: Guides/standalones.schelp block 1 (part 2/5)
(
// 1. make a copy of thisApp with the newAppName:
// can take a while on slow harddisks.
// wait for RESULT = 0 to show!

if (File.exists(~pathToNewApp).not) {
	~copyFolder.(~pathToThisApp, ~pathToNewApp);
	File.mkdir(~newAppSupportDir);
} { warn("supportDir % already exists.".format(~pathToNewApp)) };
);
