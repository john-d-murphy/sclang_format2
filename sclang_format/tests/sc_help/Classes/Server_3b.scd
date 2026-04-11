// Source: Classes/Server.schelp block 3 (part 2/2)
(
o = ServerOptions.new;
o.maxLogins = 2;
t = Server.remote(\remote, NetAddr("192.168.0.130", 57110), o); // set to correct address and port
// info about returned client ID should be posted in the post window
t.makeWindow; // make a window for monitoring
)
