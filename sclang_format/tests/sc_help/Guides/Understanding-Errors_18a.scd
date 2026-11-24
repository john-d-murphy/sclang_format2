// Source: Guides/Understanding-Errors.schelp block 18 (part 1/7)
{ while { 0.9.coin } {
    var a;	// variable here prevents optimization
    a = 10.rand;
    a.postln
  }
}.def.dumpByteCodes;
