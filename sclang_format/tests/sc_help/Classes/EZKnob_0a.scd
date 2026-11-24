// Source: Classes/EZKnob.schelp block 0 (part 1/2)
(
w = Window.new.front;
g = EZKnob(w,        // parent
            50@90,    // bounds
            " test ", // label
            \freq,    // controlSpec
            { |ez| (ez.value.asString ++" is the value of " ++ ez).postln } // action
);
g.setColors(Color.grey, Color.white)
);
