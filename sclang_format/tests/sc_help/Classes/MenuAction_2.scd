// Source: Classes/MenuAction.schelp block 2
(
s.waitForBoot {
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

	~startAction = MenuAction("start")
					.action_({ ~playSynth.() })
					.icon_(~startIcon)
					.toolTip_("Start playing synth.")
					.shortcut_("space")
					.font_(Font(bold: true, size: 18));
	~stopAction = MenuAction("stop")
					.action_({ ~stopSynth.() })
					.icon_(~stopIcon)
					.toolTip_("Stop the synth.")
					.enabled_(false)
					.shortcut_(".")
					.font_(Font(bold: true, size: 18));
	~playing = MenuAction("playing")
					.enabled_(false)
					.checkable_(true)
					.checked_(false);

	~view = View(bounds: 300@200).layout_(VLayout(
		ToolBar(~startAction, ~stopAction, MenuAction.separator, ~playing).focus,
		nil,
		Button().states_([["Options..."]]).action_({
			Menu(~startAction, ~stopAction, MenuAction.separator, ~playing).front;
		})
	));
	~view.onClose_({ ~stopSynth.() });

	~synth = nil;
	~playSynth = {
		if (~synth.isNil) {
			~synth = { SinOsc.ar(440) * 0.1 }.play;

			~startAction.enabled = false;
			~stopAction.enabled = true;
			~playing.checked = true;

			~synth.onFree({
				~synth = nil;
				{
					~playing.checked = false;
					~startAction.enabled = true;
					~stopAction.enabled = false;
				}.defer
			})
		}
	};

	~stopSynth = {
		~synth !? { ~synth.free };
	};

	~view.front;

}
)
