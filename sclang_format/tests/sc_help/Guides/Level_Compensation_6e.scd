// Source: Guides/Level_Compensation.schelp block 6 (part 5/9)
{ SplayAz.ar(4, Saw.ar({ exprand(100, 500) }! n), level: (1/n).sqrt, levelComp: false) }.scope;
