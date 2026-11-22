// Source: Classes/ArrayedCollection.schelp block 56
(
a = (0..100) ++ (100..50) / 100; // distribution
a = a.asRandomTable;
20.do { a.tableRand.postln };
)
