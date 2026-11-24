// Source: Classes/EZKnob.schelp block 1 (part 6/20)
(
w = Window("EZKnob", Rect(380, 400, 300, 180)).front;
w.view.decorator = FlowLayout(w.view.bounds);
k = EZKnob(w, 42 @ 74, "Knob", action: { |knb| knb.value.postln }, margin: 2@2, labelHeight: 16);
k.view.background_(Color.grey.alpha_(0.4));
)
