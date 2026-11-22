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
// Nothing is run: .compile turns the text into a Function and never calls it.
// Nothing here touches a server. The last line quits, whatever happened.

var dump, dir;

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

{
	dir = thisProcess.argv[0] ?? { Error("judge.scd: no directory given").throw };
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
	};
	"@@judge done".postln;
}.try { |error| error.reportError };
0.exit;
