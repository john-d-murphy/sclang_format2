// Source: Classes/RangeSlider.schelp block 2
(

w = Window("setDeviation", Rect(300, 300, 300, 150));
a = RangeSlider(w, Rect(10, 10, 200, 30))
    .lo_(0)
    .hi_(1);
b = Slider(w, Rect(10, 50, 200, 30))
    .action_(
        {   arg me;
            a.setDeviation(c.value, b.value);
        });
c = Slider(w, Rect(10, 100, 200, 30))
    .action_(
        {   arg me;
            a.setDeviation(c.value, b.value);
        }
    );
c.valueAction = 0.2;
w.front;
)
