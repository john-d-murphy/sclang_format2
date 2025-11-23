(
// block brace spacing – messy on purpose

[1, 2, 3].do{ |x|
    x.postln;
};

foo{ |x, y|
    (x + y).postln;
};

bar (1, 2){ |x, y|
    x.postln;
};

if (true){
    "ok".postln;
};

while (false){
    "nope".postln;
};

// already good spacing should stay the same
[1, 2, 3].collect { |x| x * 2 };

// strings/comments with '{' should not change
"This has { braces } in a string".postln;
// comment: foo{ |x| x.postln; }
)

