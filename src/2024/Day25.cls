Class aoc24.Day25 Extends aoc24.Base
{

Parameter InputFile = "24-day25-test.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream = ..GetInput(filename)
    s sum = 0

	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")

    }
    s sum = "Merry Christmas!!"
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
    s sum = 0

    s keys = 0
    s locks = 0
   
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")

        if $e(line,1,1) = "#" {
            s lockID = $I(locks)
            for {
                s locks(lockID, $I(locks(lockID))) = line
                set line=stream.ReadLine()
                quit:(line="")
            }
            
        } else {
            s keyID = $I(keys)
            for {
                s keys(keyID, $I(keys(keyID))) = line
                set line=stream.ReadLine()
                quit:(line="")
            }
        }
        
    }

    do ..GetPinHeight(.locks,1,.heights)
    for i = 1:1:locks {
        KILL Lheight
        do ..GetPinHeight(.locks,i,.Lheight)
        for j=1:1:keys {
            KILL KHeight
            do ..GetPinHeight(.keys, j, .KHeight)

            s isoverlap = 0
            for k=1:1 {
                q:($get(Lheight(k),0) = 0)
                if Lheight(k) + KHeight(k) > 7 {
                    s isoverlap = 1
                }
            }
            if 'isoverlap {
                do $I(sum)
            }
        }
    }
   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    
    return sum
}

ClassMethod GetPinHeight(ByRef lockORKey, id, ByRef heights)
{
    s heights = 0
    for i=1:1:lockORKey(id) {
        for j = 1:1:$l(lockORKey(id,i)) {
            if ($e(lockORKey(id,i),j,j) = "#") {
                do $I(heights(j))
            }
        }
    }
}

}
