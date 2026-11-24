// Source: Classes/Knob.schelp block 3 (part 1/5)
(
var window, midispec;
k = Knob.new(window, Rect(20, 10, 32, 32));
midispec = [0, 127, 'linear', 1].asSpec;
window = Window.new("step Knob", Rect(640, 630, 270, 70)).front;
k.action_({ |v, x, y, m| midispec.map(v.value).postln })
       .value_(midispec.unmap(0));

k.mode = \vert;

)
