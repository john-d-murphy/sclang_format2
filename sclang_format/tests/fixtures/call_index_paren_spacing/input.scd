(
// call / index paren spacing – messy on purpose

foo (1, 2);
bar  ( a, b, c );
baz ((a + b), [1, 2, 3]);

// indexing
var arr = [10, 20, 30];
arr [0];
arr  [1];
arr[
    2
];

// keyword forms should keep space: if ( ... ), while ( ... ), for ( ... )
if (foo > 0) {
    foo (1);
};

while (arr[0] > 0) {
    arr [0] = arr [0] - 1;
};

for (0, 10, 1, { |i|
    i.postln;
});

// strings/comments not touched
"This has foo (1, 2) and arr [0]".postln;
// comment: foo (1, 2)
)

