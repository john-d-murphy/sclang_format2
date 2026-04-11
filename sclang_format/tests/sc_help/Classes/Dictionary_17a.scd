// Source: Classes/Dictionary.schelp block 17 (part 1/4)
(
d = Dictionary.newFrom([
	0, \zero,
    \abc, \alpha,
    [1, 2, 3, 5, 8, 13, 21], \fibonacci,
    { |x| try { x.even } }, \even // try is needed because argument might not be a number
    ]);
);
