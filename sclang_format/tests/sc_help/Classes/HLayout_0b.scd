// Source: Classes/HLayout.schelp block 0 (part 2/6)
(
var view = ScrollView();
view.canvas = View().layout_(HLayout(
	*(
		100.collect {
			Slider().orientation_(\vertical).background_(Color.rand)
		}
	)
));
view.front;
)
