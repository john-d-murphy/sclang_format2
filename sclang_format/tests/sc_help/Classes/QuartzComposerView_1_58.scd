// Source: Classes/QuartzComposerView.schelp block 1 (part 59/76)
(
{
loop({
{ Pan2.ar(Saw.ar(mul: 0.1) * EnvGen.ar(Env.perc, timeScale: 4, doneAction: Done.freeSelf), m.x_pos) }.play;
1.wait;
});
}.fork(AppClock);
)
