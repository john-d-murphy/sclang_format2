// Source: Classes/VLayout.schelp block 0 (part 2/6)
(
var view = ScrollView();
view.canvas = View().layout_(VLayout(
	*(
		100.collect {
			Slider().orientation_(\horizontal).background_(Color.rand)
		}
	)
));
view.front;
)
