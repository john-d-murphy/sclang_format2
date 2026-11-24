// Source: Tutorials/GUI/create_window.schelp block 8
(
var window = Window();

var layout = HLayout();

var button = Button(window);
button.string_("Click me!");

// Assign the layout to the window
window.layout_(layout);
// Then add the View to the layout
layout.add(button);

window.front;
)
