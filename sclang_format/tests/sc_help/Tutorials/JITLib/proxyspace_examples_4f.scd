// Source: Tutorials/JITLib/proxyspace_examples.schelp block 4 (part 6/8)
~lfo = (~lfo3 / 50).sin * 200 + 500 * { LFTri.kr(~lfo.kr * 0.0015, 0, 0.1 * ~lfo3.kr / 90, 1) };
