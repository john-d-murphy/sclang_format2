// Source: Classes/Dunique.schelp block 1
{ var x = Dunique(Drand([0, 1, 2, 3, 4, 5], inf), 20); { Duty.ar(0.5e-4 + 0.001.rand, 0, x, doneAction: Done.freeSelf) } ! 3}.plot;
