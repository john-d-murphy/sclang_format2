// Source: Classes/FreqScopeView.schelp block 2 (part 11/11)
{ |in| MoogFF.ar(in, freq: MouseX.kr(10, 10000, 1),
gain: MouseY.kr(4, 0)) }.scopeResponse
