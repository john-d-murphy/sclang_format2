// Source: Classes/QuartzComposerView.schelp block 1 (part 74/76)
(
w = Window("Level Meters", Rect(128, 64, 200, 400)).front;

m = QuartzComposerView(w, Rect(20, 20, 50, 360));
m.path = "Help/GUI/Cocoa-GUI/QuartzComposerView/SCLevelMeter.qtz".standardizePath;
m.maxFPS_(20);
m.start;
)
