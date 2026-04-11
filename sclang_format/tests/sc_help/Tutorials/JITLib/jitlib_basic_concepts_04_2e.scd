// Source: Tutorials/JITLib/jitlib_basic_concepts_04.schelp block 2 (part 5/9)
~y = { Ringz.ar(Impulse.ar(~tempo.kr), 600, 0.05).dup }; // impulse uses tempo
~x = Pbind(\instrument, \default, \freq, Pseq([300, 400], inf));
