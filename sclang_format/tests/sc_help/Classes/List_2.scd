// Source: Classes/List.schelp block 2
(
// Create a new empty List with size: 3
x = List.new(3);

x.postln; // -> List[ ]

// Add numbers 0 to 4 to the List
5.do({ |i| x.add(i) });

// The list has been modified in-place with each added item
x.postln; // -> List[ 0, 1, 2, 3, 4 ]
)
