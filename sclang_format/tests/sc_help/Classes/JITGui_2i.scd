// Source: Classes/JITGui.schelp block 2 (part 9/18)
(	// recommended: use a FlowLayout.
w = Window().front;
w.addFlowLayout;
EZSlider(w, 300@100, \test, []);
g = JITGui(Ndef(\a), 0, w, bounds: 300@40);
)
