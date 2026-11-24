// Source: Classes/Knob.schelp block 0 (part 1/14)
(
var window, size = 32; // try different sizes - from 15 to 200 or more!
window = Window.new("Knob", Rect(640, 630, 270, 70)).front;
k = Knob.new(window, Rect(20, 10, size, size));
k.action_({ |v, x, y, m| postf("action func called: %\n", v.value) });
// k.color[1] = Color.gray(alpha: 0);
)
