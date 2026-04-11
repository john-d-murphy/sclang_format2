// Source: Classes/Pcollect.schelp block 1
(
a = Pseq( #[ 1, 2, 3 ], inf ).collect( { arg item; item * 3 } );
a.postln;

x = a.asStream;
9.do( { x.next.postln; } );
)
