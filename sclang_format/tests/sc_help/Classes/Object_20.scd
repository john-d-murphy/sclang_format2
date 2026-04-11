// Source: Classes/Object.schelp block 20
(
x = nil;
y = Point(3,4);
z = Point(5,6);
x !? { |x| y !? { |y| z !? { |z|  x.rho * y.rho * z.rho } } }
)
