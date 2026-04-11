// Source: Tutorials/JITLib/proxyspace_examples.schelp block 20
q[\in][1] = { Impulse.ar(2, 0, 0.5) }; // adding a synth at index 1

// equivalent to
q.at(\in).put(1, { Impulse.ar(7, 0, 0.5) });
