// Source: Classes/Plotter.schelp block 3 (part 5/6)
(
s.waitForBoot{
    var modeList = [
        \points, \dots, \levels, \steps,
        \lines, \plines, \dlines,
        \stems, \pstems, \dstems,
        \filled, \dfilled, \pfilled, \bars,
    ];
    modeList.clump((modeList.size/2).ceil).do{ |modes, i|
        var frq = 1000, w = 600, h = 800;
        p = {
            LFSaw.ar(frq) ! modes.size
        }.plot(2.25 * frq.reciprocal);

        0.25.wait; // let Plotter update with data
        p.plotMode_(modes);
        p.axisLabelX_(modes.collect(_.asString));
        p.setProperties(\labelFont, (Font().size_(15)));
        p.parent.bounds_(Rect(0, 0, w, h).left_(w*i));
    };
}
)
