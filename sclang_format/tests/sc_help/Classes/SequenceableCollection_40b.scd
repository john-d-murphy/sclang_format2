// Source: Classes/SequenceableCollection.schelp block 40 (part 2/2)
[[1, 2, 3], 1, [7, 8]].flopWith{ |a,b,c| a+b+c }; // shorter array wraps

// typical use case (pseudocode)
[synths, buffers].flopWith{ |a,b| a.set(\buf, b) }
