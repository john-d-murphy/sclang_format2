// Source: Classes/FlowLayout.schelp block 1
(
w = Window.new.front;
w.addFlowLayout( 10@10, 20@5 ); // a shortcut method, see SCContainerView
16.do{ Slider2D( w.view,80@80 ).background_( Color.rand ) };
)
