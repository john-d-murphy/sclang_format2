// Source: Classes/SubsampleOffset.schelp block 0 (part 2/5)
(
var dt = s.sampleRate.reciprocal; // 1 sample delay
s.sendBundle(0.2, [9, \Help_SubsampleOffset, s.nextNodeID, 1, 1, \out, 40, \addOffset, 3]);
s.sendBundle(0.2 + dt, [9, \Help_SubsampleOffset, s.nextNodeID, 1, 1, \out, 40, \addOffset, 0]);
)
