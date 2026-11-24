// Source: Classes/KeyState.schelp block 0 (part 2/3)
(
w = Window.new("I catch keystrokes");
w.view.keyDownAction = { |view, char, modifiers, unicode, keycode|  [char, keycode].postln };
w.front;
)
