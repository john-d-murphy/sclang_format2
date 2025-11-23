(
// no-final-semicolon – ORIGINAL

// simple function: last statement ends with ';' → should drop it
f = {
    var c = 1 + 2;
    c.asString;
};

// arg block form
g = { |a, b|
    var c;
    c = a + b;
    c;
};

// trailing closure if with two blocks
if (flag) {
    "true".postln;
} {
    "false".postln;
};

// single-expression block with semicolon
h = {
    1;
};

// multiple statements: only the last semicolon should go
i = {
    1;
    2;
    3;
};

// already clean: no semicolon after last expr
j = {
    "already clean"
};

// last semicolon followed by a comment on same line – we *do not* touch it yet
k = {
    "with comment";  // this semicolon should remain
};

// strings / comments with "};" patterns should be untouched
"This looks like a block }; but isn't".postln;
// comment: };
)

