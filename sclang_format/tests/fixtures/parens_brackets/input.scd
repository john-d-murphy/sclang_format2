(
// paren / bracket interior spacing – messy on purpose

// function calls
foo ( a, b );
bar(  a,  b, c  );
baz( ( a + b ), [ 1,2, 3 ] );

// grouping
(
    ( a + b ) * ( c - d )
).postln;

// arrays
[ 1,2 , 3 ];
[  [ 1, 2 ] , [ 3 ,4 ]  ];
[ "a" , "b" , "c"  ];

// indexing / subscripts
var arr = [ 10, 20, 30 ];
arr [ 0 ];
arr[  1 ];
arr  [  2  ];

// ensure strings/comments with brackets/parens not touched
"This has ( a, b ) and [ 1, 2 ] inside a string".postln;
// comment: foo ( a, b );
/* block: [ 1, 2, 3 ] */
)

