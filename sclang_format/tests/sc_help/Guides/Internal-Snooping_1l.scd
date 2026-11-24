// Source: Guides/Internal-Snooping.schelp block 1 (part 12/14)
(
// print all classes whose names start with 'F'
Class.allClasses.do { | class |
	if (class.name.asString.beginsWith("F")) {
		class.name.postln
	}
}
)
