// Source: Classes/NdefGui.schelp block 4 (part 1/2)
(
	p = ProxySpace.push(s.boot);

l = NdefGui(nil, 3).moveTo(10, 120);
m = NdefGui(nil, 3).moveTo(10, 240);
n = NdefGui(nil, 3).moveTo(10, 360);
o = NdefGui(nil, 3).moveTo(10, 480);

Spec.add(\dens, [0.1, 300, \exp]);

	// make 3 kinds of proxies: using tilde/proxyspace, Ndef, and unnamed.
~spacy = {|dens=5| Formlet.ar(Dust.ar(dens ! 2), LFDNoise0.kr(20 ! 2).lag(0.1).linexp(-1, 1, 300, 5000), 0.003, 0.03) };
Ndef(\ndeffy, { GrayNoise.ar( 0.1 ! 2) });
c = NodeProxy.audio.source_({ PinkNoise.ar(0.1 ! 2) });

	// put one in each editor
l.object_(~spacy);
m.object_(Ndef(\ndeffy));
n.object_(c);
)
