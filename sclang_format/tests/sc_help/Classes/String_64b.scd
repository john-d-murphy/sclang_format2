// Source: Classes/String.schelp block 64 (part 2/2)
"echo one; sleep 1; echo two; sleep 1".unixCmd { |res, pid| [\done, res, pid].postln };
