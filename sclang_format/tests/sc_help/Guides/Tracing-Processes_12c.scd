// Source: Guides/Tracing-Processes.schelp block 12 (part 3/3)
{ SinOsc.ar(SinOsc.kr(0.2, 0, 300, 400).poll(label: "freq")) * 0.1 }.play;
