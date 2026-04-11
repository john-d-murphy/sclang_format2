// Source: Tutorials/Mark_Polishook_tutorial/16_Playbuf.schelp block 0 (part 3/3)
(
// a simple example of component reuse ... use the \bus argument to assign synths built from
// the same synthdef to different channels
// in this case, play a 1-channel soundfile on 2 channels
// a different playback rate for each channel makes the effect more obvious
Synth("aMonoSamplePlayer", [\bus, 0, \bufNum, b, \rateScale, 0.99]);
Synth("aMonoSamplePlayer", [\bus, 1, \bufNum, b, \rateScale, 1.01]);
)
