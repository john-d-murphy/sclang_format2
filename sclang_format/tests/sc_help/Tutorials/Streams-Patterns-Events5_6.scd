// Source: Tutorials/Streams-Patterns-Events5.schelp block 6
~midinote = {
		(~note.value + ~gtranspose + (~octave * divs) + ~root)
				* 12.0 / ~stepsPerOctave;
	};
