// Source: Other/JITLibChanges3.7.schelp block 2 (part 781/815)
f = { |x, func| x.envir.keys.as(Array).sort.collect { |key| func.(x.envir.at(key)) } };
