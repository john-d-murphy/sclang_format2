// Source: Classes/Done.schelp block 1
play {
    var env = Line.kr(1,0,2);
    var sig = PinkNoise.ar(env);
    FreeSelf.kr(TDelay.kr(Done.kr(env),3));
    GVerb.ar(sig,70,7);
}
