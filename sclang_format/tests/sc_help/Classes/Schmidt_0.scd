// Source: Classes/Schmidt.schelp block 0
out[i] = if(in[i] < lo[i]) {
    0
} {
    if(in[i] > hi[i]) {
        1
   } {
        out[i-1]
   }
};
