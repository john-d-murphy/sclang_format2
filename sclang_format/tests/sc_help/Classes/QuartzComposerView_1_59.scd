// Source: Classes/QuartzComposerView.schelp block 1 (part 60/76)
(
w = Window("Sonogram", Rect(0, 20, 600, 300)).front;
m = QuartzComposerView(w, Rect(0, 20, 600, 256));
m.path = Platform.helpDir +/+ "QC/SCQCsonogramCount2.qtz";
m.start;
m.setInputValue(\framesPerView, 300);
m.setInputValue(\magnitudes, (0, 0.01..1));
)
