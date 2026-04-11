// Source: Overviews/SymbolicNotations.schelp block 12
f = { |slider, parent|
    slider = slider ?? { Slider.new(parent, Rect(0, 0, 100, 20)) };
    slider.value_(0);
};
