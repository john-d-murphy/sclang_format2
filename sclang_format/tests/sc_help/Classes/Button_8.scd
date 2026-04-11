// Source: Classes/Button.schelp block 8
(
var w, f, slots;
var insert, remove;

slots = Dictionary.new;

remove = {arg slot, id;
	[slot, id].postln;
};

insert = {arg slot, fx;
	if(fx != ""){
		slots["slot"++slot].value_(0).states_([[fx, Color.white, Color.blue]]);
		[slot, fx].postln;
	}{
		slots["slot"++slot].value_(0).states_([["", Color.white, Color.white]]);
		remove.value(slot, fx);
	};
};

w = Window.new("",Rect(200, 400, 448, 180));
w.view.decorator = f = FlowLayout(w.view.bounds);

StaticText(w, 400@20).string_("Drag & Drop holding down Cmd-key");
f.nextLine;
6.do{arg i;
	var fxwin, winOpen = false, empty = ["", Color.white, Color.white];

	slots["slot" ++ i] = Button.new(w, 70@70)
		.states_([empty])
		.action_({|v|
			if((slots["slot" ++ i].states[0][0] != "") && ( winOpen == false)) {
				fxwin = Window(slots["slot" ++ i].states[0][0], Rect(rrand(0, 500),rrand(0, 500),200, 200)).front;
				fxwin.view.background_(Color.rand);
				fxwin.onClose_({ winOpen = false});
				winOpen = true
			} {
				if(winOpen == true) {
					fxwin.front
				}
			}; })
		.canReceiveDragHandler_({ View.currentDrag.isString })
		.receiveDragHandler_({ insert.value(i, View.currentDrag) })
		.beginDragAction_({
			var drag;
			drag = slots["slot" ++ i].states[0][0];
			slots["slot" ++ i].value_(0).states_([empty]);
			remove.value(i, View.currentDrag);
			drag; })
		.keyDownAction_({ arg view,char,modifiers,unicode,keycode;
			switch(keycode)
				{ 51 } {
					slots["slot"++i].value_(0).states_([empty]);
					slots["slot"++i].refresh;
					remove.value(i, View.currentDrag);
				}; });
};

f.nextLine;

["a", "b", "c", "d", "e", "f"].do{ arg item, i;
	Button.new(w, 70@70)
	.states_([ [ item ] ])
	.action_({ |v| })
	.beginDragAction_({item})
};
w.front;
)
