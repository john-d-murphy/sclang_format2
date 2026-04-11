// Source: Classes/UnitTest.schelp block 9
(
a = UnitTest.new;
a.ifAsserts(2 == 3, "yes", { a.assert(2 == 4) }, { a.assert(1 == 1, "but this is correct") });
)
