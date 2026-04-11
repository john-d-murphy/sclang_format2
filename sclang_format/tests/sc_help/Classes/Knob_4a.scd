// Source: Classes/Knob.schelp block 4 (part 1/2)
(
var size = 28;
w = Window.new("Knobs", Rect(250,500,270,70));
w.acceptsMouseOver=true; // must be true in parent window!
w.view.decorator = FlowLayout(w.view.bounds);
h = StaticText(w, 150 @ 10);
w.view.decorator.nextLine;
k = Array(8);
8.do({|item, i|
    var knob;
    knob = Knob.new(w, size @ size)
        .action_({|v,x,y,m| h.string = "val: " ++ v.value.asString; })
        .mouseOverAction_({|v,x,y| h.string = "val: " ++ v.value.asString; });

    k = k.add(knob);
});
w.front
)
