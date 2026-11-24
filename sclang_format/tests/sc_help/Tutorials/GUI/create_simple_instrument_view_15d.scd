// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 15 (part 4/4)
var durSlider = Slider()
.orientation_(\horizontal)
.maxHeight_(60)
.action_({ dur = ControlSpec(durMin, durMax, \lin).map(durSlider.value); });
