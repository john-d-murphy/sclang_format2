// Source: Classes/ToolBar.schelp block 1
(
s.waitForBoot {
	~synth = nil;
	~freq = 300;

	~startIcon = Image(40).draw({
		Pen.fillColor = Color.green;
		Pen.moveTo(5@5);
		Pen.lineTo(35@20);
		Pen.lineTo(5@35);
		Pen.lineTo(5@5);
		Pen.fill;
	});

	~stopIcon = Image(40).draw({
		Pen.fillColor = Color.red;
		Pen.fillRect(Rect(10, 10, 20, 20));
	});

	~freqMenu = Menu(
		MenuAction("100"),
		MenuAction("200"),
		MenuAction("300"),
		MenuAction("400"),
		MenuAction("500"),
	).title_(~freq);

	~updateFunc = {
		|obj, what, action|
		if (what == \triggered) {
			~freq = action.string.asInteger;
			~freqMenu.title = ~freq;
			~synth !? { ~synth.set(\f, ~freq) };
		}
	};

	~freqMenu.addDependant(~updateFunc);

	~play = MenuAction("play")
		.icon_(~startIcon)
		.action_({
			if (~synth.isNil) {
				~synth = { |f| SinOsc.ar(f) * 0.1 }.play(args: [\f, ~freq]);
				~synth.onFree { ~synth = nil };
				~play.icon = ~stopIcon;
			} {
				~synth.free;
				~play.icon = ~startIcon;
			}
		});

	~toolBar = ToolBar(~play, ~freqMenu).minWidth_(200).front;
	~toolBar.onClose_({ ~freqMenu.removeDependant(~updateFunc) })
}
)
