// Source: Classes/FlowLayout.schelp block 7
(
w = Window.new;
w.view.decorator = d = FlowLayout.new( w.view.bounds, 10@10, 20@5 );
Slider2D( w.view,100@160 ).background_( Color.rand );
Slider2D( w.view,150@150 ).background_( Color.rand );
"first row maxHeight: " ++ d.maxHeight.postln;
Slider2D( w.view,150@150 ).background_( Color.rand );
"second row maxHeight: " ++ d.maxHeight.postln;
w.front;
)
