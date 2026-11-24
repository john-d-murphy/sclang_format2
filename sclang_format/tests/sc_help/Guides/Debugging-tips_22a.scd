// Source: Guides/Debugging-tips.schelp block 22 (part 1/6)
(
var	positiveFunc;
positiveFunc = { |a|
	a.debug('positiveFunc-arg a');
	a.dumpBackTrace;
	a*10
};
a = 5;
if (a > 0) { positiveFunc.value(a) };
)
