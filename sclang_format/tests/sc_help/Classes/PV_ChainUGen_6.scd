// Source: Classes/PV_ChainUGen.schelp block 6
{ | magnitude, phase, bin, index |
	// randomize magnitudes somewhat (noisier signal)
	[magnitude * (5.0.rand2.dbamp), phase]
}
