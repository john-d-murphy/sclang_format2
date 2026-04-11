// Source: Classes/FlowLayout.schelp block 10
(
w = Window.new;
w.view.decorator = d = FlowLayout.new( w.view.bounds, 10@10, 20@5 );
Slider2D( w.view,100@160 ).background_( Color.rand );
d.used.postln;
Slider2D( w.view,150@150 ).background_( Color.rand );
d.used.postln;
Slider2D( w.view,150@150 ).background_( Color.rand );
d.used.postln;
w.front;
)
