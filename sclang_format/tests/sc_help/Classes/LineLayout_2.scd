// Source: Classes/LineLayout.schelp block 2
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
