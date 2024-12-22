Class aoc24.Day11 Extends aoc24.Base
{

Parameter InputFile = "24-day11.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

    s stones = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        for i=1:1:$l(line," ") {
            continue:($PIECE(line," ",i)="")
            s stones($I(stones)) = $PIECE(line," ",i)
        }
    }

    s sum = ..sovlePart2(.stones)
    
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

    s stones = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        for i=1:1:$l(line," ") {
            continue:($PIECE(line," ",i)="")
            s stones($I(stones)) = $PIECE(line," ",i)
        }
    }

    for i=1:1:25 {
        s sum = ..Blink(.stones)
    }
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod Blink(ByRef stones) As %Integer
{
    s stoneID = ""
    s totalStones=stones
    for stoneID=1:1:totalStones{
        s newStone = stones(stoneID)
        do ..ApplyRule(stones(stoneID), .newStone)
        s stones(stoneID) = newStone(0)
        if (newStone=2) {
            s stones($I(stones)) = newStone(1)
        }
        KILL newStone
    }
    return stones
}

ClassMethod ApplyRule(Stone, ByRef newStone)
{
    s newStone = 1
    if (Stone = 0) {
        s newStone(0) = 1
    } elseif ($LENGTH(Stone)#2 = 0) {
        s newStone = 2
        s newStone(0) = $EXTRACT(Stone,0,$l(Stone)\2) + 0
        s newStone(1) = $EXTRACT(Stone,($l(Stone)\2)+1,*) + 0
    } else {
        s newStone(0) = Stone*2024
    }
}

ClassMethod Part2Sol(ByRef stones, ByRef ans)
{
    for i=1:1:25 {
        do ..Blink(.stones)
    }

    s st=""

    s ans = stones
    for{
        s st=$o(stones(st))
        q:(st="")
        do $I(ans(stones(st)))
    }
}

ClassMethod sovlePart2(ByRef stones) As %Integer
{
    s dp = 0
    s sum = 0
    for i=1:1:stones {
        if $get(dp(stones(i)),-1)=-1 {
            KILL tstones,ans
            s tstones=1
            s tstones(1) = stones(i)
            do ..Part2Sol(.tstones,.ans)
            Merge dp(stones(i)) = ans
        }
        s p1 = stones(i)
        s p2 = ""
        for {
            s p2 = $order(dp(p1,p2))
            q:(p2="")
            if $get(dp(p2),-1)=-1 {
                KILL tstones,ans
                s tstones=1
                s tstones(1) = p2
                do ..Part2Sol(.tstones,.ans)
                Merge dp(p2) = ans
            }
            s p3 = ""
            for {
                s p3 = $order(dp(p2,p3))
                q:(p3="")
                if $get(dp(p3),-1)=-1 {
                    KILL tstones,ans
                    s tstones=1
                    s tstones(1) = p3
                    do ..Part2Sol(.tstones,.ans)
                    Merge dp(p3) = ans
                } 
                s sum = sum + (dp(p3)*dp(p2,p3)*dp(p1,p2))
            }
        }
    }
    return sum
}

}
