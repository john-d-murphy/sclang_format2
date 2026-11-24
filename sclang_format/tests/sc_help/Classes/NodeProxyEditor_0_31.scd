// Source: Classes/NodeProxyEditor.schelp block 0 (part 32/41)
(	// keys go away if not needed
~test = { |freq = 300, dens = 20, amp = 0.1|
	Pan2.ar(Ringz.ar(Dust.ar(dens, amp / (dens.max(1).sqrt)), freq, 0.2))
};
)
