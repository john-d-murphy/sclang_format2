// Source: Classes/EZSlider.schelp block 0 (part 2/2)
(
	g = EZSlider(label:" test ");
	g.action_({ |ez| (ez.value.asString ++" is the value of " ++ ez).postln });
);
