// Source: Guides/Debugging-tips.schelp block 20 (part 1/3)
(
var	positiveFunc;
positiveFunc = { |a|
	a.debug('positiveFunc-arg a');
	a*10
};
a = 5;
if (a > 0) { positiveFunc.value(a) };
)
