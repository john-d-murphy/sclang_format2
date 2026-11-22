// Source: Classes/SimpleController.schelp block 0
(
var controller, model, view;

model = Ref(0.5);
controller = SimpleController(model);
controller.put(\value,
	{ |theChanger, what, moreArgs|
		view.value_(theChanger.value);
	});

view = Slider(Window("slider", Rect(100, 100, 330, 38)).front, Rect(5, 5, 320, 20));
view.onClose_{ controller.remove };

// run a routine to change the model's value:
r{
	100.do{
		model.value_(1.0.rand.postln).changed(\value);
		0.5.wait;
	}
}.play(AppClock)
)
