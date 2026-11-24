// Source: Classes/EZSlider.schelp block 0 (part 1/2)
(
w = Window.new.front;
g = EZSlider(w,         // parent
              390@20,    // bounds
              " test ",  // label
              \freq,     // controlSpec
              { |ez| (ez.value.asString ++" is the value of " ++ ez).postln } // action
);
g.setColors(Color.grey, Color.white)
);
