// Source: Guides/MultiClient_Setups.schelp block 2 (part 44/45)
Ndef(\x).filter(10, { |in| Ringz.ar(in, [600, 800], 0.03) }).play;
