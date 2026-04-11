// Source: Classes/EZRanger.schelp block 1 (part 7/7)
(
w = Window("cow herd").front;
w.view.decorator_(FlowLayout(w.bounds.copy.moveTo(0, 0)));

Spec.add(\ring, [0.03, 30, \exp]);
Spec.add(\num, [3, 30, \exp, 1]);

EZRanger(w, 390@20, "numRange", \num, { |sl| q.numRange = sl.value; }, labelWidth: 65)
	.round_(1);

EZRanger(w, 390@20, "freqRange", \freq, { |sl| q.freqRange = sl.value; }, q.freqRange, labelWidth: 65)
	.round_(0.1);
EZRanger(w, 390@20, "ringRange", \ring, { |sl| q.ringRange = sl.value; }, q.ringRange, labelWidth: 65)
	.round_(0.0001);
EZRanger(w, 390@20, "ampRange", \amp, { |sl| q.ampRange = sl.value; }, q.ampRange, labelWidth: 65)
	.round_(0.0001);
Button(w, 190@20).states_([[\newSound]]).action_({~plong = q[\soundfunc] });
)
