// Source: Classes/HID.schelp block 0 (part 7/8)
HIDdef.usage( \freq, { |value| Ndef( \sinewave ).set( \freq, ~freqRange.map( value ) ); }, \X );
