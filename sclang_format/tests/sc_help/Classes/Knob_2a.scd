// Source: Classes/Knob.schelp block 2 (part 1/4)
(
var window;
k = Knob.new(window, Rect(20, 10, 36, 36));
window = Window.new("Pan Knob", Rect(640, 630, 270, 70)).front;
k.action_({ |v, x, y, m| \pan.asSpec.map(v.value).postln })
//  .mode_(\horiz)
    .centered_(false)
    .value_(\pan.asSpec.unmap(0)); // 0.5
// k.color[1] = Color.gray(alpha: 0);
)
