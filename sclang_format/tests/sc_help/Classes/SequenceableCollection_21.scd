// Source: Classes/SequenceableCollection.schelp block 21
#[a, b, c, g, h, h, j, h].rejectIndicesAs({|item, i| item === \h}, Set)
