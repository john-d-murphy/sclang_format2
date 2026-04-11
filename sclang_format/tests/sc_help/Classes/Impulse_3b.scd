// Source: Classes/Impulse.schelp block 3 (part 2/2)
fork { (1 / (1..60).scramble).do { |dt| Synth.grain(\imp);  dt.wait } };
