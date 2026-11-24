// Source: Overviews/GenericCollectors.schelp block 6 (part 4/4)
{ |event| event.use { ~x = ~x + 1 }; event }.transformEvent((x: 8));
