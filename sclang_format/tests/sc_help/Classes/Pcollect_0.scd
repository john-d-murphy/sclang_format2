// Source: Classes/Pcollect.schelp block 0
(
a = Pcollect( { |item| item * 3 }, Pseq( #[ 1, 2, 3 ], inf ) );
x = a.asStream;
9.do( { x.next.postln; } );
)
