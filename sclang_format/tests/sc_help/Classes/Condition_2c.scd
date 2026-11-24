// Source: Classes/Condition.schelp block 2 (part 3/6)
(
c = Condition.new;
fork { loop { 1.wait; "going".postln; c.wait } };
)
