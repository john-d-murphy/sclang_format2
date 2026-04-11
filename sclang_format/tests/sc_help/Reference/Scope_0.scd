// Source: Reference/Scope.schelp block 0
(
var makeCounter;
makeCounter = { arg curVal=0, stepVal=1;
     // return a function :
    {
        var temp;
        // temp is local to this function, curVal & stepVal in the
        // enclosing function are referred to here within.
        temp = curVal;
        curVal = curVal + stepVal;
        temp                       // return result
    }
};

// Each invocation of makeCounter creates a new set of variables curVal and stepVal:

x = makeCounter.value(10, 1);
z = makeCounter.value(99, 100);
)
