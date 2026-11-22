// The judge: sclang decides what is SuperCollider.
//
//     sclang tests/judge.scd <directory>
//
// Compiles every .scd file under the directory, in path order, and posts one
// record per file:
//
//     @@judge file <path>
//     ...whatever sclang posts while compiling it (its error messages)...
//     @@judge accepted <the compiled function, written out>
//  or @@judge refused
//
// sclang posts its compile errors and gives the code no way to read them, so
// the reason for a refusal is read from the text between the two lines by
// whoever runs this (tests/sclang_judge.rs).
//
//     sclang -l <configuration> tests/judge.scd <directory> classes
//
// Class files are compiled only into the class library, when sclang starts:
// the configuration names the directory as an include path, and this posts
// what the library then holds from it, one line per class and per method,
// in order of name:
//
//     @@judge class <name> <path, from the directory> <its superclass, variables and constants>
//     @@judge method <class>:<name> <path, from the directory> <the method, written out>
//
// A class file sclang refuses stops the library from compiling, and then
// sclang never gets as far as this file.
//
// Nothing is run: .compile turns the text into a Function and never calls it.
// Nothing here touches a server. The last line quits, whatever happened.

var dump, dir, files, classes;

// Everything the compiler made, on one line, so that two compilations can be
// compared as text: the bytecode, the literals (a nested function is one of
// them, written out the same way), the constants, the defaults, the names of
// arguments and variables, and their counts. A float is written with its
// bits, since its printed form rounds. The source text is left out, and so is
// the context, which points back up to the enclosing function.
dump = { |x|
	case
	{ x.isKindOf(FunctionDef) } {
		"{code:%; selectors:%; constants:%; defaults:%; args:%; vars:%; numArgs:%; numVars:%; varArgs:%}".format(
			dump.(x.code), dump.(x.selectors), dump.(x.constants), dump.(x.prototypeFrame),
			dump.(x.argNames), dump.(x.varNames), x.numArgs, x.numVars, x.varArgsValue
		)
	}
	{ x.isKindOf(Float) } { "%<%:%>".format(x, x.high32Bits, x.low32Bits) }
	{ x.isString or: { x.isKindOf(Symbol) } } {
		x.asCompileString.replace("\n", "\\n").replace("\r", "\\r")
	}
	{ x.isKindOf(ArrayedCollection) } {
		x.class.name ++ "[" ++ x.asArray.collect(dump).join(", ") ++ "]"
	}
	{ x.asCompileString }
};

files = {
	PathName(dir).deepFiles
	.select { |p| p.extension == "scd" }
	.collect(_.fullPath)
	.sort
	.do { |path|
		var function;
		("@@judge file " ++ path).postln;
		function = File.readAllString(path).compile;
		if(function.isNil) {
			"@@judge refused".postln
		} {
			("@@judge accepted " ++ dump.(function.def)).postln
		}
	}
};

// A method is a FunctionDef with a name and, it may be, a primitive.
classes = {
	var from = { |x| x.filenameSymbol.asString.beginsWith(dir) };
	var all = Class.allClasses.copy.sort { |a, b| a.name <= b.name };
	all.select(from).reject(_.isMetaClass).do { |class|
		"@@judge class % % {superclass:%; instVars:%; instDefaults:%; classVars:%; classDefaults:%; consts:%; constValues:%}".format(
			class.name, class.filenameSymbol.asString.drop(dir.size), class.superclass.name,
			dump.(class.instVarNames), dump.(class.iprototype),
			dump.(class.classVarNames), dump.(class.cprototype),
			dump.(class.constNames), dump.(class.constValues)
		).postln
	};
	all.do { |class|
		(class.methods ? []).select(from).copy.sort { |a, b| a.name <= b.name }.do { |method|
			"@@judge method %:% % {primitive:%; %}".format(
				class.name, method.name,
				method.filenameSymbol.asString.drop(dir.size),
				method.primitiveName.asCompileString, dump.(method)
			).postln
		}
	}
};

{
	dir = thisProcess.argv[0] ?? { Error("judge.scd: no directory given").throw };
	if(thisProcess.argv[1] == "classes", classes, files).value;
	"@@judge done".postln;
}.try { |error| error.reportError };
0.exit;
