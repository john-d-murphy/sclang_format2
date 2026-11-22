// Source: Classes/NdefGui.schelp block 1 (part 1/4)
Ndef(\1, {
	SinOsc.ar(freq: 100.collect{|i|
		"freq%".format(i).asSymbol.kr(100, spec: Spec.specs[\freq])
	})
});
