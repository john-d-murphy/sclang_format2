// Source: Classes/Integer.schelp block 18 (part 2/2)
v.keyDownAction = { |view, char, modifiers|
    case
    { modifiers.isAlt } { \alt }
	{ modifiers.isCaps } { \caps }
	{ modifiers.isCmd } { \cmd }
	{ modifiers.isCtrl } { \ctrl }
	{ modifiers.isFun } { \fun }
	{ modifiers.isHelp } { \help }
	{ modifiers.isNumPad } { \numpad }
    { modifiers.isShift } { \shift }
    .postln
};
