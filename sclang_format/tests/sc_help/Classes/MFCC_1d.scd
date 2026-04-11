// Source: Classes/MFCC.schelp block 1 (part 4/6)
(
a = Array.fill(220, {|i| 
	var f = i * 100; 
	11.17 * log((f + 312) / (f + 14675)) + 43.0 
})
)
