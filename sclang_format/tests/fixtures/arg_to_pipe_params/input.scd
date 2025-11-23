(
// arg → pipe conversion

x = {
    arg foo = 3, bar = 4.dbamp;
    foo + bar;
};

y = {
    arg a;
    var z;
    z = a * 2;
    z;
};

// arg inside if-branches
if (true) {
    arg n;
    n.postln;
} {
    "else".postln;
};
)

