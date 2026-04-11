// Source: Classes/AbstractFunction.schelp block 60
(
Environment.use {
	~y = 10;
	~x = 2;
	~z = { |x=8| x } + { |y=0| y + 1.0.rand };
	~z.valueEnvir;
}
)
