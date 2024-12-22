Class aoc24.Day2 Extends aoc24.Base
{

Parameter InputFile = "24-day2.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        kill levels
        set sc = ..ParseString(line, .levels)

        if 'sc || ($get(levels(1)) = "") {
            w "Error: ",sc,!
            break
        }
        for i=0:1:$ORDER(levels(""),-1)+1 {
            s isSafe = ..IsSafe(.levels, i)
            q:isSafe
        }
        if isSafe {
            s sum = sum + 1
        }
    }
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod Part1(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        kill levels
        set sc = ..ParseString(line, .levels)

        if 'sc || ($get(levels(1)) = "") {
            w "Error: ",sc,!
            break
        }
        s isSafe = ..IsSafe(.levels)
        if isSafe {
            s sum = sum + 1
        }

    }
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod IsSafe(ByRef levels, skip = 0) As %Integer
{
    /*
    * Checks is levels are safe
    * 1. The levels are either all increasing or all decreasing (cond2 variable)
    * 2. Any two adjacent levels differ by at least one and at most three.
    * Can also tolerate a single bad level defined by **skip**
    */
    s cond2 = -1 // O means increasing - 1 means decreasing
    s isSafe = 1
    
    for i = 2:1 {
        quit:($GET(levels(i), "") = "")
        if (i = skip) continue
        if ((skip = 1) && (i = 2)) continue 
        
        s prev = i-1
        set:(prev = skip) prev = prev - 1
        s isSafe = 0
        s diff = levels(i) - levels(prev)
        s absDiff = $ZABS(diff)

        if cond2 = -1 {
            s cond2 = 0
            if (diff < 0) s cond2 = 1

        } else {
            if (((diff < 0) && (cond2 = 0)) || ((diff > 0) && (cond2 = 1))) {
                q
            }
        }
        if ((absDiff < 1) || (absDiff > 3)) {
            q
        }
        
        s isSafe = 1
    }
    return isSafe
}

}
