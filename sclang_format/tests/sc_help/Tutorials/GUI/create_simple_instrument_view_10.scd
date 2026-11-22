// Source: Tutorials/GUI/create_simple_instrument_view.schelp block 10
(
var window = Window();
var firstLayout = VLayout();
var secondLayout = HLayout();

var topButton = Button().string_("top").maxHeight_(200);

var leftButton = Button().string_("left").maxHeight_(200);
var rightButton = Button().string_("right").maxHeight_(200);

// The window is divided vertically, using a VLayout:
window.layout_(firstLayout);

// We're adding two objects, this will split the window in two:

// This will cover the top side of the window:
firstLayout.add(topButton);

// This will cover the bottom side of the window:
firstLayout.add(secondLayout);

// The bottom of the screen is a HLayout, so it's subdivided horizontally
// In two, because we add two objects:
secondLayout.add(leftButton);
secondLayout.add(rightButton);

window.front;
)
