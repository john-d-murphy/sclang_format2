// Source: Classes/Object.schelp block 21
(
x = Point(1,2);
y = Point(3,4);
z = Point(5,6);
x !? { |x| y !? { |y| z !? {  |z| x.rho * y.rho * z.rho } } }
)
