// Source: Classes/TextField.schelp block 0 (part 1/8)
(
w = Window.new.front;
a = TextField(w, Rect(10, 10, 150, 20));
a.string = "hi there";
a.action = {arg field; field.value.postln; };
)
