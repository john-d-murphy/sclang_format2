// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 4
(
var window = Window();
var layout = HLayout();
var button = Button();
var button2 = Button();

button.string_("Play");
button.action_({ Synth(\instrView); });

button2.string_("Play 2");
button2.action_({ Synth(\instrView); });

window.layout_(layout);

layout.add(button);
layout.add(button2);

window.front;
)
