// Source: Tutorials/JITLib/proxyspace_examples.schelp block 1 (part 2/4)
~out = { SinOsc.ar([400, 408] * 0.8, 0, 0.2) };


// replacing the node. the crossfade envelope is created internally.
~out = { SinOsc.ar([443, 600 - Rand(0,200)], 0, 0.2) };
