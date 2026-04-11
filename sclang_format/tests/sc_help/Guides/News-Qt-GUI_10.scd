// Source: Guides/News-Qt-GUI.schelp block 10
(
var v, s;
v = SoundFileView().front;
s = Signal.sineFill(1000, 1.0/[1,2,3,4]);
v.alloc(5000, samplerate: 500);
3.do { |i| v.set( i * 2000, s * (1/(i+1)) ) };
)
