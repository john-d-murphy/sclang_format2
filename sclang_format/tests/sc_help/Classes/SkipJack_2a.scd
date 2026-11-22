// Source: Classes/SkipJack.schelp block 2 (part 1/4)
(
d = (a: 12, b: 24);
d.win = Window("dict", Rect(0, 0, 200, 60)).front;
d.views = [\a, \b].collect { |name, i|
    StaticText(d.win, Rect(i * 100, 0, 96, 20))
        .background_(Color.yellow).align_(0).string_(name);
};
w = SkipJack({
        "...".postln;
        [\a, \b].do { |name, i|
            d.views[i].string_(name ++ ":" + d[name])
        }
    },
    0.5,
    { d.win.isClosed },
    "showdict"
);
)
