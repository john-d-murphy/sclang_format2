// Source: Classes/PV_Div.schelp block 0 (part 3/3)
(
p = Plotter.new;
t = Task {
	loop {
		0.1.wait;
		b.loadToFloatArray(action: { |data|
			{
			p.value = data[2..]
				.clump(2)
				.collect { |a| a[0].squared + a[1].squared }
				.collect { |a| if(a.isNaN) { 0.post } { a } }
		}.defer
		})
} }.play;
)
