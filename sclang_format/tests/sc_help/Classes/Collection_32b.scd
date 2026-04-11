// Source: Classes/Collection.schelp block 32 (part 2/4)
b = a.collectCopy { |x| if(x.even) { a.remove(x); "removed" } { x }  };
