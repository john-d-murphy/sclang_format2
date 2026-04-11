// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/12.schelp block 5 (part 3/3)
(
Synth.head(~effect, "soundFileFilter", [\out, 0, \freq, 500.rrand(1000), \rq, 0.04.rrand(0.1)]);
Synth.head(~source, "aMonoSamplePlayer", [\bus, 0, \bufNum, b]);
)
