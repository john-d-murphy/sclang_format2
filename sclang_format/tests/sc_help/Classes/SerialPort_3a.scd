// Source: Classes/SerialPort.schelp block 3 (part 1/4)
(
p = SerialPort(
	"/dev/tty.usbserial-A800crTT",	//edit to match your port. SerialPort.listDevices
	baudrate: 9600,	//check that baudrate is the same as in arduino sketch
	crtscts: true);
)
