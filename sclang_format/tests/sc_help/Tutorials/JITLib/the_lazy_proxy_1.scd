// Source: Tutorials/JITLib/the_lazy_proxy.schelp block 1
~x = { Array.fill(14, { SinOsc.kr(1.0.rand, 0, 100) }) }; //~x is now 14 channels control rate
~x;
