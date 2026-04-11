// Source: Classes/UnitTest.schelp block 10
(
{
	s.reboot;
	UnitTest.new.wait({ s.serverRunning }, "server failed to boot in time", 2);
}.fork
)
