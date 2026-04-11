// Source: Tutorials/Getting-Started/13-Buffers.schelp block 3
PlayBuf.ar(
	1,				// number of channels
	bufnum, 			// number of buffer to play
	BufRateScale.kr(bufnum)		// rate of playback
	)
