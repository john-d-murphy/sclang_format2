// Source: Classes/EZKnob.schelp block 0 (part 2/2)
(
	g = EZKnob(label:" test ");
	g.action_({ |ez| (ez.value.asString ++" is the value of " ++ ez).postln });
);
