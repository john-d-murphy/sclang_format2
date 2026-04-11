// Source: Classes/PriorityQueue.schelp block 0 (part 1/7)
(
var p;
p = PriorityQueue.new;

p.put(0.1, \a);
p.put(2.0, \b);
p.put(0.5, \c);
p.put(0.2, \d);
p.put(1.0, \e);

while ({ p.notEmpty },{
	[p.topPriority, p.pop].postln;
});


p.pop.postln;
p.pop.postln;
p.pop.postln;

)
