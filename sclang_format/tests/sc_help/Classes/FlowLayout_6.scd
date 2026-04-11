// Source: Classes/FlowLayout.schelp block 6
(
w = Window.new;
w.view.decorator = d = FlowLayout.new( w.view.bounds, 10@10, 20@5 );
Slider2D( w.view,150@150 ).background_( Color.rand );
d.top_(50); //manually set the new indentation
Slider2D( w.view,150@150 ).background_( Color.rand );
Slider2D( w.view,150@150 ).background_( Color.rand );
w.front;
)
