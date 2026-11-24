// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 2
(
var window = Window();
var layout = HLayout();
var button = Button();

button.string_("Play");

window.layout_(layout);
layout.add(button);

window.front;
)
