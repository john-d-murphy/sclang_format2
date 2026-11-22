// Source: Classes/QuartzComposerView.schelp block 1 (part 1/76)
(
w = Window("Simple QC Test").front;
b = Button(w, Rect(0, 0, 150, 20))
	.states_([["pick another QC file"]])
	.action_({ File.openDialog("", { |path| m.path_(path) }) });
m = QuartzComposerView(w, Rect(0, 20, 400, 260));
m.path = Platform.helpDir +/+ "QC/Cells.qtz";
)
