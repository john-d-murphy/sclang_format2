// Source: Classes/Collection.schelp block 34 (part 2/4)
b = a.collectCopy { |x| if(x.even) { a.remove(x); "removed" } { x } };
