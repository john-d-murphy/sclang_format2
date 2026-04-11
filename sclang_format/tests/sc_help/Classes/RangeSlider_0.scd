// Source: Classes/RangeSlider.schelp block 0
(
w = Window.new.front;
a = RangeSlider(w, Rect(20, 80, 120, 30))
    .lo_(0.2)
    .range_(0.4)
    .action_({ |slider|
        [\sliderLOW, slider.lo, \sliderHI, slider.hi].postln;
    });
)
