// Source: Classes/EZText.schelp block 0 (part 3/3)
(
	g = EZText(bounds: Rect(100, 200, 150, 50), label:" test ", layout: \vert);
	g.action_({ |ez| (ez.value.asString ++" is the value of " ++ ez).postln });
);
