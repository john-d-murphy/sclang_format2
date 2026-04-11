// Source: Classes/LID.schelp block 8
(
d.slot(0x0002, 0x0001).action = { | slot |
	[slot.type.asHexString(4), slot.code.asHexString(4), slot.value].postln;
}
)
