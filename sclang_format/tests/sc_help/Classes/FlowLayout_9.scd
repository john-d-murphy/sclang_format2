// Source: Classes/FlowLayout.schelp block 9
(
w = Window.new;
w.view.decorator = d = FlowLayout.new( w.view.bounds, 10@10, 10@5 );
Slider2D( w.view,100@160 ).background_( Color.rand );
d.currentBounds.postln;
Slider2D( w.view,150@150 ).background_( Color.rand );
d.currentBounds.postln;
Slider2D( w.view,150@150 ).background_( Color.rand );
d.currentBounds.postln;
w.front;
)
