// Source: Guides/Tour_of_UGens.schelp block 20 (part 1/4)
(
// allocate tables 80 to 87
8.do {|i| s.sendMsg(\b_alloc, 80+i, 1024); };
)
