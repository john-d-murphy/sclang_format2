// Source: Guides/Internal-Snooping.schelp block 1 (part 14/14)
(
// find and print all methods that contain "ascii"
Class.allClasses.do { | class |
   	class.methods.do { | sel |
   			if(sel.name.asString.find("ascii").notNil) {
            		(class.name.asString + "-" + sel.name).postln
            }
	}
}
)
