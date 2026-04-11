// Source: Classes/Window.schelp block 5 (part 1/3)
(
x = Window.new.front;
x.alpha = 0.8;
x.onClose_({ y = Synth.new(\default) }); //close the window and the synth plays
)
