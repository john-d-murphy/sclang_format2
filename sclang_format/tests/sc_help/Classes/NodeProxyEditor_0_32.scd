// Source: Classes/NodeProxyEditor.schelp block 0 (part 33/41)
(	// and are added in order if needed
~test = { |freq = 300, intv = 0, dens = 20, amp = 0.1, pan, pok, ting|
	Pan2.ar(
		Ringz.ar(
			Dust.ar(dens ! 2, amp / (dens.max(1).sqrt)),
			freq * [intv, intv.neg].midiratio, 0.2))
};
)
