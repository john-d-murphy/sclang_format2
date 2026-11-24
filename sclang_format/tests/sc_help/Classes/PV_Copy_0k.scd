// Source: Classes/PV_Copy.schelp block 0 (part 11/15)
(
~fftSize = 2048;
~allBuffers = ();
~copyToBuffer = { |chain, name|
	var buffer = Buffer.alloc(s, ~fftSize);
	~allBuffers.put(name, buffer);
	PV_Copy(chain, buffer)
};
)
