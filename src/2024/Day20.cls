Class aoc24.Day20 Extends aoc24.Base
{

Parameter InputFile = "24-day20.txt";

ClassMethod Part2(filename = "", startFrom = 99) As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

	s map = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()

        s map($I(map)) = line
    }

    s startAddr = ..findCharInMap(.map, "S")
    s endAddr = ..findCharInMap(.map, "E")

    s sum = ..findScoresFromStartingPos(.map,startAddr,endAddr,20,startFrom)
    
   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod Part1(filename = "", startFrom = 99) As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

    s map = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()

        s map($I(map)) = line
    }

    s startAddr = ..findCharInMap(.map, "S")
    s endAddr = ..findCharInMap(.map, "E")

    s sum = ..findScoresFromStartingPos(.map,startAddr,endAddr,2,startFrom)

    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod findCharInMap(ByRef map, char)
{
    for i=1:1:map {
        for j=1:1:$l(map(i)) {
            if ($e(map(i),j,j) = char) {
                return i_","_j
            }
        }
    }
    return -1_","_-1
}

ClassMethod findShortestPath(ByRef map, start, end, ByRef visited, ByRef pqueue)
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

        continue:($Get(visited(cX,cY),9999999) <= gn)
        s visited(cX,cY) = gn
        continue:($e(map(cX),cY,cY) = "#")

        if ((cX = endX) && (cY = endY)) {
            s:(ans > gn) ans = gn
        }
        set nextPos = "-1,0|0,1|1,0|0,-1"
        for i=1:1:$l(nextPos,"|") {
            s nX = $p($p(nextPos,"|",i),",",1)
            s nY = $p($p(nextPos,"|",i),",",2)

            s newX = nX + cX
            s newY = nY + cY
            continue:((newX <= 1) || (newX >= map))
            continue:((newY <= 1) || (newY >= $l(map(newX))))
            
            s curScore = gn + 1 
            s newQueueElement = newX_"|"_newY_"|"_curScore
            S pqueue(curScore, $I(pqueue(curScore))) =  newQueueElement
            
        }
    }
    return ans
}

ClassMethod findScoresFromStartingPos(ByRef map, start, end, totalCheatTime, threshold = 99)
{
    KILL uniqueNodes,pqueue
    s pqueue = 1
    s pqueue(0) = 0
    s pqueue(0,0) = $p(start,",",1)_"|"_$p(start,",",2)_"|0"
    
    do ..findShortestPath(.map,start,end,.uniqueNodes, .pqueue)

    s answer = 0
    for i=2:1:(map-1) {
        for j=2:1:($l(map(i))-1) {
            continue:($e(map(i),j,j) = "#")
            continue:($get(uniqueNodes(i,j),-1) = -1)

            s di = 0
            for dj = 1:1:totalCheatTime {
                s delti = di + i
                s deltj = dj + j

                continue:((delti <= 1) || (delti >= map))
                continue:((deltj <= 1) || (deltj >= $l(map(delti))))
                continue:($e(map(delti),deltj,deltj) = "#")
                
                s scoreAfterCheat = $get(uniqueNodes(delti,deltj),-1)
                continue:(scoreAfterCheat = -1)

                if ..calcCost(uniqueNodes(i,j), uniqueNodes(delti,deltj), $zabs(di) +$zabs(dj) ) > 99 {
                    if ($GET(answer(i,j,delti,deltj),0) = 0) {
                        s answer(i,j,delti,deltj) = 1
                        do $I(answer)
                    }
                }
            } 
            for di = 1:1:totalCheatTime {
                for dj = (di-totalCheatTime):1:(totalCheatTime-di) {
                    s delti = di + i
                    s deltj = dj + j

                    continue:((delti <= 1) || (delti >= map))
                    continue:((deltj <= 1) || (deltj >= $l(map(delti))))
                    continue:($e(map(delti),deltj,deltj) = "#")
                    s scoreAfterCheat = $get(uniqueNodes(delti,deltj),-1)
                    continue:(scoreAfterCheat = -1)

                    if ..calcCost(uniqueNodes(i,j), uniqueNodes(delti,deltj), $zabs(di) +$zabs(dj) ) > threshold {
                        if ($GET(answer(i,j,delti,deltj),0) = 0) {
                            s answer(i,j,delti,deltj) = 1
                            do $I(answer)
                        }
                    }
                }
                
            } 
        }
    }
    return answer
}

ClassMethod calcCost(a, b, steps)
{
    if a > b {
        return a - (b+steps)
    } else {
        return b - (a+steps)
    }
}

}
