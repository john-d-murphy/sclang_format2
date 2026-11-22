// An ordinary class: variables, a constructor, a setter, methods that end in
// a return, and a method that takes the rest of its arguments.
Voice : Object {
    classvar <all, <>latency=0.2;
    var <name, <>level, medium, prState;
    const maxLevel=1.0;

    *initClass { all=IdentityDictionary.new; }

    *new { arg name, medium, level=0.5;
        ^super.new.init(name, medium, level);
    }

    init { |aName, aMedium, aLevel|
        name=aName;
        medium = aMedium;
        level = aLevel.clip(0, maxLevel);
        prState = ();
        all[name]=this;
        ^this
    }

    name_ { |aName| name = aName; }

    play { arg freq=440, dur=1 ... more;
        if(level>0, {
            medium.emit(\note, freq, dur, *more);
        }, {
            "silent".postln;
        });
        ^this;
    }

    isPlaying { ^prState[\playing] ? false }

    free {
        all.removeAt(name);
        prState.clear;
    }

    onDone { |action=({})| prState[\done]=action }

    printOn { |stream| stream << "Voice(" << name << ")"; }
}
