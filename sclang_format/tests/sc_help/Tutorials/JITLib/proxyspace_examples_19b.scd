// Source: Tutorials/JITLib/proxyspace_examples.schelp block 19 (part 2/3)
(
p = ProxySpace(s);
q = ProxySpace(s);

p.use({
	~out = { Resonz.ar(~in.ar, ~freq.kr, 0.01) };
	~in = { WhiteNoise.ar(0.5) };
	~freq = { LFNoise2.kr(1, 1000, 2000) };
});

q.use({
	~in = { Dust.ar(20, 0.1) };
	~out = { Resonz.ar(~in.ar * 450, ~freq.kr, 0.005) };
	~freq = { LFNoise2.kr(1, 400, 2000) };
});
)
