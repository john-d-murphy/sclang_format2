// Source: Classes/Plotter.schelp block 18 (part 9/12)
(
var ys, xs; // ys: data, xs: domain positions
var rs = 0, plt2;

// xs are the sample points over a 2pi range

// sample locations, normalized
xs = 50.collect({rrand(0.05, 1)}).normalizeSum;
xs.do{ |me, i| xs[i] = me + rs; rs = rs + me; };

// force beginning/end to land on 0/2pi
xs[0] = 0;
xs[xs.size-1] = 1;

// scale these points to a 2pi range
xs = xs * 2pi;

// ys are the values of the sinusoid at the sampled points
ys = sin(xs);

// the uneven sampling is apparent when
// displayed as uniformly sampled
ys.plot("original data plot, uniform domain", [100, 100, 385, 285].asRect);

// generate a second plot whose domainSpec is specified:
// we see a smooth sinusoid cycle beginning
// at 0 and ending at 2pi
plt2 = ys.plot("resampled domain", [100+400, 100, 385, 285].asRect);

// domain values place plotted points where they
// actually sampled the sinusoid, thus visually
// reconstructing it.
plt2.domain = xs;

// these values are placed within the domainSpec
// so we can pad the plot on either side.
plt2.domainSpecs_(([-0.5pi, 2.5pi]).asSpec);
)
