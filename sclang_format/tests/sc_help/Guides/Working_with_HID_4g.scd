// Source: Guides/Working_with_HID.schelp block 4 (part 7/8)
HIDdef.usage( \freq, { |value| Ndef( \sinewave ).set( \freq, ~freqRange.map( value ) ); }, \X );
