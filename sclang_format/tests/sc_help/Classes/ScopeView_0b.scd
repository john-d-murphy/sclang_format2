// Source: Classes/ScopeView.schelp block 0 (part 2/6)
(
f = Buffer.alloc(s, 1024, 2);
b = Bus.audio(s, 1);

w = Window.new.front;
w.onClose = { // free everything when finished
    c.stop; a.free; d.free; f.free; b.free;
    "SynthDefs, busses and buffers have all been freed.".postln;
};
c = ScopeView(w.view, w.view.bounds.insetAll(10, 10, 10, 10));
c.bufnum = f.bufnum;
c.server = s; // Important: one must assign the ScopeView to a server
)
