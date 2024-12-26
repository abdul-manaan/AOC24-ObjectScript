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

    s stones = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        for i=1:1:$l(line," ") {
            continue:($PIECE(line," ",i)="")
            s stones($I(stones)) = $PIECE(line," ",i)
        }
    }

    s sum = ..solveForNumberOfBlinks(.stones, 75)
    
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

    s stones = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        for i=1:1:$l(line," ") {
            continue:($PIECE(line," ",i)="")
            s stones($I(stones)) = $PIECE(line," ",i)
        }
    }

    s sum = ..solveForNumberOfBlinks(.stones, 25)
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
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

ClassMethod solveForNumberOfBlinks(ByRef stones, numberOfBlinks) As %Integer
{
   
    s stonesCopy = ""
    for i=1:1:stones {
        do $I(stonesCopy(0,stones(i)))
    }
    
    for i=1:1:numberOfBlinks {
        s it = ""
        for {
            s it = $o(stonesCopy(i-1,it))
            q:(it="")
            do ..ApplyRule(it, .newStone)
            
            
            s multiplier = stonesCopy(i-1,it)
            s stonesCopy(i,newStone(0)) = $GET(stonesCopy(i,newStone(0)),0) + multiplier
            if newStone = 2 {
                s stonesCopy(i,newStone(1)) = $GET(stonesCopy(i,newStone(1)),0) + multiplier
            }
        }
    }
    s it = "" 
    s sum = 0
    for {
        s it = $O(stonesCopy(numberOfBlinks,it))
        q:(it="")
        s sum = sum + stonesCopy(numberOfBlinks,it)
    }
    return sum
}

}
