// Source: Classes/LID.schelp block 3 (part 2/2)
(
LID.register('Logitech WingMan RumblePad', (
	// key
	rumble: #[0x0001, 0x0102],	// rumble (toggles ff)
	mode: #[0x0001, 0x0103],	// mode (switches h and l)
	a: #[0x0001, 0x0120],		// button a
	b: #[0x0001, 0x0121],		// button b
	c: #[0x0001, 0x0122],		// button c
	x: #[0x0001, 0x0123],		// button x
	y: #[0x0001, 0x0124],		// button y
	z: #[0x0001, 0x0125],		// button z
	l: #[0x0001, 0x0126],		// left front button
	r: #[0x0001, 0x0127],		// right front button
	s: #[0x0001, 0x0128],		// button s
	// abs
	lx: #[0x0003, 0x0000],		// left joystick x
	ly: #[0x0003, 0x0001],		// left joystick y
	rx: #[0x0003, 0x0005],		// right joystick x
	ry: #[0x0003, 0x0006],		// right joystick y
	hx: #[0x0003, 0x0010],		// hat x
	hy: #[0x0003, 0x0011],		// hat y
	slider: #[0x0003, 0x0002]	// slider
));
)
