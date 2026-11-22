// Source: Classes/Stream.schelp block 11
(
a = Routine({ 20.do({ 33.rand.yield }) });
b = Routine({ [-100, 00, 300, 400].do({ |v| v.yield }) });
[
	'+', '-', '*', '/', \div, '%', '**', 
	'<', '<=', '>', '>=', '&', '|', \min, \max,
	\bitXor, \lcm, \gcd, \round, \trunc, \atan2,
	\hypot, '>>', '+>>', \ring1, \ring2, \ring3, \ring4,
	\difsqr, \sumsqr, \sqrdif, \absdif, \amclip,
	\scaleneg, \clip2, \excess, '<!', \rrand, \exprand
]
.do({ |msg|
	postf("\n msg: % \n", msg);
	b.reset.perform(msg).do({ |v| v.post; " ".post });
});
nil;
)
