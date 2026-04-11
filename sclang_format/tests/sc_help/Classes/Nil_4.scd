// Source: Classes/Nil.schelp block 4
[nil, 2, nil, 3].collect { |x| x ?? { 100.rand } }; // replace nil by a random number
