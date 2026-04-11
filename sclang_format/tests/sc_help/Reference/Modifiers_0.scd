// Source: Reference/Modifiers.schelp block 0
(
w = Window.new.front; w.addFlowLayout;

	// direct, using bit field
Button(w, Rect(0,0,390,50)).states_([["hold shift/alt keys and click"]])
	.action_ { |but, mod|
		if (mod & 131072 == 131072) { "shift key was pressed.".postln; };
		if (mod & 524288 == 524288) { "alt key was pressed.".postln; };
	};

	// using helper methods
Button(w, Rect(0,0,390,50)).states_([["hold any mod keys and click"]])
	.action_ { |but, mod|
		if(mod.isCaps) { "mod pressed: Caps.".postln };
		if(mod.isShift) { "mod pressed: Shift.".postln };
		if(mod.isCtrl) { "mod pressed: Ctrl.".postln };
		if(mod.isAlt) { "mod pressed: Alt.".postln };
		if(mod.isNumPad) { "mod pressed: NumPad.".postln };
		if(mod.isHelp) { "mod pressed: Help.".postln };
		if(mod.isFun) { "mod pressed: Fun.".postln };
	};

	// collecting all modifiers
Button(w, Rect(0,0,390,50)).states_([["hold any mod keys and click"]])
	.action_ { |but, mod|
		var pressed;
		#[\isCaps, \isShift, \isCtrl, \isAlt, \isCmd, \isNumPad, \isHelp, \isFun].do { |x|
			if(mod.perform(x)) { pressed = pressed.add(x) }
		};
		pressed.postln;
	};
)
