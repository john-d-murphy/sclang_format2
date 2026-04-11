// Source: Classes/RangeSlider.schelp block 1
(
w = Window.new.front;
a = RangeSlider(w, Rect(20, 80, 120, 30))
    .lo_(0.2)
    .hi_(0.8)
    .action_({ |slider|
        b.activeLo_(slider.lo); // this will trigger the action of b (and set it's value)
        b.hi_(slider.hi);
    });
b = RangeSlider(w, Rect(220, 80, 20, 130))
    .lo_(0.2)
    .hi_(0.8)
    .knobColor_(HiliteGradient(Color.grey, Color.white,\h))
    .action_({ |slider|
        [\sliderLOW, slider.lo, \sliderHI, slider.hi].postln;
    });

)
