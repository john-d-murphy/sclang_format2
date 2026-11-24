(
// The layout of code is decided by the code, not by the line breaks it was
// typed with. Each of these stands at the indent it has in the file it was
// taken from.

// Declarations too wide for one line get a line each (at 12 columns),
// whatever line breaks they were typed with.
~answer = { |me|
    me.requests.do { |msg|
        me.guard {
            var why = refusal.(msg.source, msg.part,
                msg.values), token = msg.values[1];
            reply.(why, token)
        }
    }
};

// A chain that is a statement breaks before each of its operators (at 8).
~isName = { |x|
    me.guard {
        x.isKindOf(Symbol) and: { x != \none } and: { x.asString.notEmpty } and: { x.asString.every { |c| c.isPrint } };
        x
    }
};

// A call with two blocks among its arguments: the parentheses are opened,
// and the arguments fit on the line they get (at 4).
~relays = { |me|
    var made = me.once(\made, { IdentityDictionary.new }, { |relays| relays.do(_.free) });
    made
};

// Arguments wrapped by hand over two lines of 99 columns: one to a line
// (at 8).
~relay = { |name|
    me.guard {
        var relay = super.newCopyArgs(name, Medium.default, TempoClock.default, MBState.new, false,
            List.new, List.new, IdentityDictionary.new, false, nil, nil, Dictionary.new, List.new);
        relay
    }
};

// A block of two statements is always open.
if (told[member] != place) { told[member] = place; tell.(member) };

// A block of one statement stands on one line whenever the line fits.
SynthDef(\x, { |out|
    Out.ar(out, SinOsc.ar)
}).add;

f = { |x|
    x + 1
};

// The block that is the last argument, and the only block, hugs its call.
SynthDef(\x, { |out| var sig = SinOsc.ar; Out.ar(out, sig) }).add;

me.on('/here/*', { |msg| first.(msg); second.(msg) });

// It does not when the line of its brace would be too wide: then the
// parentheses are opened, and each argument too wide for its line in turn.
serve.(MBAddress.format(\here, someLongName, anotherLongArgument, yetAnotherOne, andOneMoreStill), { |msg| first.(msg); second.(msg) });

// Nor when it is not the last argument.
me.sched({ |time| first.(time); second.(time) }, 0.5);

// Outside parentheses a block is opened where it stands: after a call,
// after a control structure, and assigned.
names.do { |name| first.(name); second.(name) };

while { queue.notEmpty } { first.(queue.pop); second.value };

~tell = { |member| first.(member); second.(member) };
)
