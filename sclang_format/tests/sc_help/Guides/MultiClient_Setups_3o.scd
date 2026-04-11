// Source: Guides/MultiClient_Setups.schelp block 3 (part 15/15)
3.collect { Bus.audio(r, 2) }; // 512, 514, 516
// control bus range starts at 8192 of 16384 total range
3.collect { Bus.control(r, 2) };
