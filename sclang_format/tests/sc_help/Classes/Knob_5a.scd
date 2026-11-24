// Source: Classes/Knob.schelp block 5 (part 1/8)
(
var w, txt, size = 36;
w = Window.new("Knobs", Rect(400, 400, 250, 100)).front;
w.acceptsMouseOver = true;
w.view.decorator = FlowLayout(w.view.bounds).gap_(10 @ 10).margin_(10 @10);
txt = StaticText(w, 200 @ 14);
w.view.decorator.nextLine;

k = Knob(w, size @ size);
k.action = { |v, x, y|  v.value.postln; txt.string_("value: " ++ v.value) };
k.mouseOverAction = { |v| txt.string_("value: " ++ v.value) };

j = Knob(w, size @ size);
j.action = { |v, x, y|  j.value.postln; txt.string_("value: " ++ v.value) };
j.mouseOverAction = { txt.string_("value: " ++ j.value) };

n = NumberBox(w, 100 @ 20);
// n.setProperty(\boxColor, Color.grey(alpha: 0.0));
n.value = 0.0;
)
