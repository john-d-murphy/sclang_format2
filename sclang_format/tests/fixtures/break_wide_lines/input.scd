(
// A line over 80 is broken: the outermost thing on it that can be, and then
// the lines that leaves. Each of these stands at the indent it has in the
// file it was taken from.

// A block is opened; its body, at 20 columns and 84 wide, then has its
// call's arguments put on a line of their own.
~report = { |me|
    me.reactions.do { |next|
        if (next.notNil) {
            me.guard {
                MBTry.value(next[1]) { |error| me.medium.report(me.name, \reaction, next[0], error.errorString) }
            }
        }
    }
};

// The block is opened; then the parentheses of the if, like an argument
// list; then the chain in them breaks before each of its operators.
~forget = { |me|
    me.names.do { |name|
        me.lock.critical {
            if (me.live) {
                me.heard.keysDo { |key|
                    if (key == name) {
                        if (me.isDefined and: { keys[name].notNil } and: { heard[name] == time }) { remove.(name) }
                    }
                }
            }
        }
    }
};
)
