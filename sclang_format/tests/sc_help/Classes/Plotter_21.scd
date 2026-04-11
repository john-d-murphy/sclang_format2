// Source: Classes/Plotter.schelp block 21
(
var w, z, p, d, func;
w = Window("plot panel", Rect(20, 30, 520, 450));
z = CompositeView(
    w, Rect(10, 35, 490, 400)
).background_(Color.rand(0.7)).resize_(5);
p = Plotter("plot", parent: z);
d = Array.rand(32, 0, 20);
func = { |v|
	var offset = v.value.linlin(0, 1, 0, d.size.neg).asInteger;
    p.value = d.rotate(offset).keep(8);
    w.refresh;
};
Slider.new(w, Rect(10, 10, 490, 20)).resize_(2).action_({ |v| func.(v.value) });
func.value(0);
w.front;
)
