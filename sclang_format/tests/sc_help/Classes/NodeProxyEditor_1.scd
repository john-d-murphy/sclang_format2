// Source: Classes/NodeProxyEditor.schelp block 1
(
// p = ProxySpace.push(s.boot);

l = NodeProxyEditor(nil, 3); l.w.bounds_(l.w.bounds.moveBy(0, 120));
m = NodeProxyEditor(nil, 3); m.w.bounds_(m.w.bounds.moveBy(0, 240));
n = NodeProxyEditor(nil, 3); n.w.bounds_(n.w.bounds.moveBy(0, 360));
o = NodeProxyEditor(nil, 3); o.w.bounds_(o.w.bounds.moveBy(0, 480));

Spec.add(\dens, [0.1, 300, \exp]);

	// make 3 kinds of proxies: using tilde/proxyspace, Ndef, and unnamed.
~spacy = {|dens=5| Formlet.ar(Dust.ar(dens ! 2), LFDNoise0.kr(20 ! 2).lag(0.1).linexp(-1, 1, 300, 5000), 0.003, 0.03) };
Ndef(\ndeffy, { GrayNoise.ar( 0.1 ! 2) });
c = NodeProxy.audio.source_({ PinkNoise.ar(0.1 ! 2) });

	// put one in each editor
l.proxy_(~spacy);
m.proxy_(Ndef(\ndeffy));
n.proxy_(c);
)
