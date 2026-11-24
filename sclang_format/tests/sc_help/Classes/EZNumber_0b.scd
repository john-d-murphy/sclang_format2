// Source: Classes/EZNumber.schelp block 0 (part 2/2)
(
	g = EZNumber(label:" test ", controlSpec: \amp.asSpec.step_(0.01));
	g.action_({ |ez| (ez.value.asString ++" is the value of " ++ ez).postln });
);
