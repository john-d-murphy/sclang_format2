// Source: Classes/NodeProxyEditor.schelp block 0 (part 29/41)
(
~test = { |freq = 300, dens = 20, amp = 0.1, pan, ping = 12, tok = 13, crak|
	Pan2.ar(Ringz.ar(Dust.ar(dens, amp / (dens.max(1).sqrt)), freq, 0.2), pan)
};
Spec.add(\dens, [0.1, 100, \exp, 0.01, 10]);
)
