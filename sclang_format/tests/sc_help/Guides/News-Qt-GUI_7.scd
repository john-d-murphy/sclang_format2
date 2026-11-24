// Source: Guides/News-Qt-GUI.schelp block 7
(
var view, update;
update = { |v|
    var bounds = v.bounds;
    v.string = "%@%\n%x%".format(
        bounds.left,
        bounds.top,
        bounds.height,
        bounds.width
    );
};

x = StaticText(bounds:Rect(100,100,200,200)).align_(\center).font_(Font(size:25));
x.onMove = update;
x.onResize = update;
update.(x);

x.front;
)
