// Source: Classes/QuartzComposerView.schelp block 1 (part 69/76)
(
w = Window("Level Meters", Rect(128, 64, 200, 400)).front;

m = QuartzComposerView(w, Rect(20, 20, 50, 360));
n = QuartzComposerView(w, Rect(130, 20, 50, 360));
m.path = Platform.helpDir +/+ "QC/SCLevelMeter.qtz";
n.path = Platform.helpDir +/+ "QC/SCLevelMeter.qtz";
m.maxFPS_(20); n.maxFPS_(20);
m.start; n.start;
~meters = [m, n];
)
