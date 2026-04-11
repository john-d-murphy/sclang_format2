// Source: Classes/SCImageFilter.schelp block 4
(
	f = SCImageFilter.new(\CIStarShineGenerator);
	f.center_([200,200]);
	f.radius_(200*0.05);
	f.color_(Color.blue);
	f.crossWidth_(2.0);
	f.crossAngle_(0.0);
	f.crossOpacity_(-4.0);
	f.values.postln;
)
