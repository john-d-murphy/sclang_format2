(
// param list on brace line fixture

// bad: pipes on their own line
f = {
    |foo = 3, bar = 4|
    foo + bar;
};

// already good: unchanged
g = { |x, y|
    x + y;
};

// should not touch arg-style for now
h = {
    arg a, b;
    a + b;
};
)
