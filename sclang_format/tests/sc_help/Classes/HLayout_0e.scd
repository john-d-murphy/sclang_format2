// Source: Classes/HLayout.schelp block 0 (part 5/5)
(
w = Window().front;
f = { SoundFileView(w).load(Platform.resourceDir +/+ "sounds/a11wlk01.wav", 1e5.rand, 1e4) };
a = { HLayout(VLayout(*{ Slider(w, Rect(0, 0, 230, 20)).minSize_(Size(130, 20)) } ! 3), f.value) } ! 4;
w.layout = HLayout(VLayout(*a));
)
