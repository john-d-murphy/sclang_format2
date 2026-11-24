// Source: Classes/EZText.schelp block 0 (part 1/3)
(
w = Window("EZText", Rect(300, 300, 260, 60)).front;
g = EZText(w,          // parent
            250@50,     // bounds
            "testing",  // label
            { |ez| (ez.value.asString ++" is the value of " ++ ez).postln }, // action
            [1, 2, 3],  // initValue
            true        // initAction
);
g.setColors(Color.grey, Color.white);
);
