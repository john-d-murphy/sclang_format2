// Source: Classes/SimpleNumber.schelp block 15
(
	var vals = (-100..200) / 100;
	vals.collect(_.ramp).plot
	.domainSpecs_(
		[vals.minItem, vals.maxItem].asSpec
	)
	.axisLabelX_("input").axisLabelY_("output")
)
