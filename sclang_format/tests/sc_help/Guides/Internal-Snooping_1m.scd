// Source: Guides/Internal-Snooping.schelp block 1 (part 13/14)
(
// find and print all class variable names defined in the system
Class.allClasses.do { | class |
	if (class.classVarNames.notNil) {
		// classVarNames is an Array of Symbols
        class.classVarNames.do { | varname |
            (class.name.asString ++ " " ++ varname.asString).postln
        }
    }
}
)
