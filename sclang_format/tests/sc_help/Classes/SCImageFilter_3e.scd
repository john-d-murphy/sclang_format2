// Source: Classes/SCImageFilter.schelp block 3 (part 5/5)
(
f.attributes.keysDo({|attr|
	(attr ++ " = " + f.attributeRange(attr)).postln; // nil results means there is no min max for those attributes
});
)
