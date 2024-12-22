Class aoc24.Day18 Extends aoc24.Base
{

Parameter InputFile = "24-day18.txt";

ClassMethod Part2(filename = "", rows = 70, cols = 70) As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)

    s count = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s bytesFall($I(count),1) = $p(line,",",1)
        s bytesFall(count,2) = $p(line,",",2)
    }

    // THis is BINARY SEARCH
    s st = $s(rows<70:12,1:1024)
    s end = count + 1

    for {
        q:(st >= end)
        s mid = ((end-st)\2) + st + 1

        s ans = ..BinarySearch(rows,cols,mid,.bytesFall)
        if (ans = 0) {
            s end = mid -1
        } else {
            s st = mid
        }
    }

    w "SUM is: "_bytesFall(st+1,1)_","_bytesFall(st+1,2),!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return bytesFall(st+1,1)_","_bytesFall(st+1,2)
}

ClassMethod BinarySearch(rows, cols, numberOfBytesFall, ByRef bytesFall) As %Integer
{
    s rows = rows+1
    s cols = cols+1
    s map = rows
    for i = 1:1:rows {
        for j=1:1:cols {
            s $e(map(i),j,j) = "."
        }
    }

    for i=1:1:numberOfBytesFall {
        s cX = bytesFall(i,1)+1
        s cY = bytesFall(i,2)+1
        s $e(map(cY),cX,cX) = "#"
    }

    KILL pqueue,uniqueNodes
    s pqueue = 1
    s pqueue(1) = 1
    s pqueue(1,1) = "1|1|1"
    s sum = ..findShortestPath(.map,"1,1",rows_","_cols,.uniqueNodes,.pqueue) - 1

    if sum < 999999998 {
        return sum
    }
    return 0
}

ClassMethod Part1(filename = "", rows = 70, cols = 70, numberOfBytesFall = 1024) As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    s count = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s bytesFall($I(count),1) = $p(line,",",1)
        s bytesFall(count,2) = $p(line,",",2)
    }

    s sum = ..BinarySearch(rows,cols,numberOfBytesFall,.bytesFall)
   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod findShortestPath(ByRef map, start, end, ByRef uniqueNodes, ByRef pqueue)
{
    s endX = $p(end,",",1)
    s endY = $p(end,",",2)
    
    s visited = 0
    s ans = 999999999
    for {
        s it = $o(pqueue(""))
        q:(it="")

        s it2 = $o(pqueue(it,""))
        if (it2="") {
            KILL pqueue(it)
            continue
        }

        s cX = $p(pqueue(it,it2),"|",1)
        s cY = $p(pqueue(it,it2),"|",2)
        s gn = $p(pqueue(it,it2),"|",3)

        KILL pqueue(it,it2)

        continue:($e(map(cX),cY,cY) = "#")

        continue:($Get(visited(cX,cY),9999999) <= gn)
        s visited(cX,cY) = gn

        if ((cX = endX) && (cY = endY)) {
            s:(ans > gn) ans = gn
            quit
        }
        set nextPos = "-1,0|0,1|1,0|0,-1"
        for i=1:1:$l(nextPos,"|") {
            s nX = $p($p(nextPos,"|",i),",",1)
            s nY = $p($p(nextPos,"|",i),",",2)

            s newX = nX + cX
            s newY = nY + cY
            continue:((newX < 1) || (newX > map))
            continue:((newY < 1) || (newY > $l(map(newX))))
 
            s curScore = gn + 1
            s newQueueElement = newX_"|"_newY_"|"_curScore
            S pqueue(curScore, $I(pqueue(curScore))) =  newQueueElement
            
        }
    }
    return ans
}

}
