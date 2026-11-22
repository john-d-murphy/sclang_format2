// Source: Classes/EZNumber.schelp block 0 (part 1/2)
(
w = Window.new.front;
g = EZNumber(w,        // parent
             150@20,   // bounds
             " test ", // label
             \freq,    // controlSpec
             { |ez| (ez.value.asString ++" is the value of " ++ ez).postln }, // action
             330,      // initValue
             true      // initAction
);
g.setColors(Color.grey, Color.white);
);
