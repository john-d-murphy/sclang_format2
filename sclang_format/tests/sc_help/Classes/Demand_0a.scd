// Source: Classes/Demand.schelp block 0 (part 1/3)
(
a = { |t_trig, t_reset|
	var	d = Demand.kr(t_trig + t_reset, t_reset, Dseries(0, 1, inf));
	d.poll(t_trig + t_reset);
	0.0;
}.play
)
