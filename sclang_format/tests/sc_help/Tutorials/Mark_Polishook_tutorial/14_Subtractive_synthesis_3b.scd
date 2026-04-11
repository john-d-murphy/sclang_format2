// Source: Tutorials/Mark_Polishook_tutorial/14_Subtractive_synthesis.schelp block 3 (part 2/2)
(
// activate left and right channels
Synth("noiseToPitch", [\out, 0, \mul, 1]);
Synth("noiseToPitch", [\out, 1, \mul, 1]);
)
