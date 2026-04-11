// Source: Classes/Knob.schelp block 3 (part 1/3)
(
var window, midispec;
midispec = [0,127,'linear',1].asSpec;
window = Window.new("step Knob", Rect(640,630,270,70)).front;
k = Knob.new(window, Rect(20,10,32,32));
k.action_({|v,x,y,m| midispec.map(v.value).postln; })
       .value_(midispec.unmap(0));

k.mode = \vert;

)
