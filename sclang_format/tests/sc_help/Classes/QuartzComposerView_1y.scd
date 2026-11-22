// Source: Classes/QuartzComposerView.schelp block 1 (part 25/76)
(
// probably more efficient to do this in QC, but...
{
c = Color.blue;
100.do({ m.startColor_(c = c.vary(1)); 0.1.wait });
}.fork(AppClock);
)
