// Source: Classes/LID.schelp block 9
(
d.slot(0x0002, 0x0001).deltaAction = { | slot |
	[slot.type.asHexString(4), slot.code.asHexString(4), slot.delta].postln;
}
)
