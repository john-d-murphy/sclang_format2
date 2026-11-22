// Source: Classes/DebugFrame.schelp block 0
(
var debugFrame = { 1.0.getBackTrace }.();

while{ debugFrame.isNil.not }{
	var def = debugFrame.functionDef;
	def.postln;
	if(def.isKindOf(Method)){
		File.readAllString(def.filenameSymbol.asString)[def.charPos..def.charPos + 200].post;
		"...".postln;
	} {
		def.sourceCode.postln
	};
	"\n".post;
	debugFrame = debugFrame.caller
}
)
