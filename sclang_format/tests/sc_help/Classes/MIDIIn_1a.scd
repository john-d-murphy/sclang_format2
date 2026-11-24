// Source: Classes/MIDIIn.schelp block 1 (part 1/2)
(
MIDIIn.connect;	// init for one port midi interface
// register functions:
~noteOff = 	{ |src, chan, num, vel|	[chan, num, vel / 127].postln };
~noteOn = 	{ |src, chan, num, vel|	[chan, num, vel / 127].postln };
~polytouch = { |src, chan, num, vel| [chan, num, vel / 127].postln };
~control = 	{ |src, chan, num, val|	[chan, num, val].postln };
~program = 	{ |src, chan, prog|		[chan, prog].postln };
~touch = 	{ |src, chan, pressure|	[chan, pressure].postln };
~bend = 	{ |src, chan, bend|		[chan, bend - 8192].postln };
~sysex = 	{ |src, sysex|			sysex.postln };
~sysrt = 	{ |src, chan, val|		[chan, val].postln };
~smpte = 	{ |src, chan, val|		[chan, val].postln };
MIDIIn.addFuncTo(\noteOn, ~noteOn);
MIDIIn.addFuncTo(\noteOff, ~noteOff);
MIDIIn.addFuncTo(\polytouch, ~polytouch);
MIDIIn.addFuncTo(\control, ~control);
MIDIIn.addFuncTo(\program, ~program);
MIDIIn.addFuncTo(\touch, ~touch);
MIDIIn.addFuncTo(\bend, ~bend);
MIDIIn.addFuncTo(\sysex, ~sysex);
MIDIIn.addFuncTo(\sysrt, ~sysrt);
MIDIIn.addFuncTo(\smpte, ~smpte);
)
