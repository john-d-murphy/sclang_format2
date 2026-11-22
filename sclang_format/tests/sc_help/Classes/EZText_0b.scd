// Source: Classes/EZText.schelp block 0 (part 2/3)
(
	g = EZText(label:" test ");
	g.action_({ |ez| (ez.value.asString ++" is the value of " ++ ez).postln });
);
