(
// pipe param default parens – ORIGINAL

// symbol / string / bool / nil defaults: should remain unchanged
g = {
    |mode = \major, name = "foo", flag = true, nothing = nil|
    [mode, name, flag, nothing].postln;
};

// already parenthesized default: should remain unchanged
h = {
    |env = (Env.perc(0.01, 1.0))|
    env;
};

)

