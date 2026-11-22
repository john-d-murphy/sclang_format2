// Source: Guides/Level_Compensation.schelp block 0 (part 1/4)
~levelCompFactor = { |numChans=2, p_value=1|
	numChans ** p_value.clip(0, 1).neg
};
