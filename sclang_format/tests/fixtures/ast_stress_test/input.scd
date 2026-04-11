(
// AST / indentation stress test

// SECTION 1: top-level vars, arrays, events
var arr = [10, 20, 30];
var env = (
    key: "value",
    nested: [1, 2, 3],
    events: [
        (name: \a, vals: [1, 2, 3]),
        (name: \b, vals: [4, 5, 6])
    ]
);

// SECTION 2: trailing closures on collections (with nested closures)
[1, 2, 3].do { |x|
    [x, x * 2].do { |y|
        y.postln;
    };
};

// SECTION 3: trailing closures on non-collection receivers
"hello".dup(2).do { |s|
    s.postln;
};

// SECTION 4: while + indexed collections (including multi-line index)
while (arr[0] > 0) {
    arr[0] = arr[0] - 1;
    if (arr[0] == 5) {
        arr[
            0
        ] = 100;
    };
};

// SECTION 5: comma-style switch at (logical) top level
switch (arr[0],
    0, { "zero".postln },
    1, { "one".postln },
    { "other".postln }
);

// SECTION 6: block-style switch inside a function_block
{
    var z = [0, 1, 2].choose;
    switch (z)
        { 0 } { "zero".postln }
        { 1 } { "one".postln }
        { 2 } { "two".postln }
        { "other".postln };
}.value;

// SECTION 7: looks-like-event parens vs real events
(
    "this: is in a string",
    [1, 2, 3],
    (foo: "bar")  // true event nested in non-event parens
);

// SECTION 8: nested events inside array-of-events
[
    ( name: \outer,
      inner: (
          key: "value",
          list: [10, 20, 30],
          // inner comment
      )
    ),
    // second element
    (
        name: \second,
        data: [
            (id: 1, val: 10),
            (id: 2, val: 20)
        ]
    )
].do { |ev|
    ev[\name].postln;
};

// SECTION 9: function with multiple trailing closures and collections
f = { |list|
    list.collect { |x|
        if (x > 0) {
            x * 2
        } {
            x
        }
    }.select { |x|
        x % 2 == 0
    }
};

f.([1, -1, 2, -2]).do { |x|
    x.postln;
};

) // end top-level parens

