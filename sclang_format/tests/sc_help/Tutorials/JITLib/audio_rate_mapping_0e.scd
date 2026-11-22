// Source: Tutorials/JITLib/audio_rate_mapping.schelp block 0 (part 5/32)
~f3 = { |a_in=#[0,0], freq=30| a_in * LFSaw.ar(freq.neg).max(0) };
