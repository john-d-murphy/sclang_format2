// Source: Classes/SCImageFilter.schelp block 2 (part 1/3)
(
f = SCImageFilter.new(\CIStarShineGenerator);
f.attributes.keysValuesDo({|k, v|
	("CIStarShineGenerator responds to "++k.asString++"_("++v.asString++")").postln;
});
)
