Class aoc24.Day16 Extends aoc24.Base
{

Parameter InputFile = "24-day16.txt";

ClassMethod Part2(filename = "") As %Integer
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
    s start = ..findCharInMap(.map, "S")
    s end = ..findCharInMap(.map, "E")

    KILL pqueue
    s pqueue = 1
    s pqueue(1) = 1
    s pqueue(1,1) = $p(start,",",1)_"|"_$p(start,",",2)_"|"_"0|E|0"
    s sum = ..findShortestPath(.map,start,end,.uniqueNodes,.pqueue)

    KILL pqueue
    s pqueue = 2
    s pqueue(1) = 2
    s pqueue(1,1) = $p(end,",",1)_"|"_$p(end,",",2)_"|"_"0|W|0"
    s pqueue(1,2) = $p(end,",",1)_"|"_$p(end,",",2)_"|"_"0|S|0"
    do ..findShortestPath(.map,end,start,.uniqueNodes2,.pqueue)

    s count = 0

    for i=1:1:map {
        for j=1:1:$l(map(i)) {
            s direct="NESW"
            continue:($e(map(i),j,j)="#")
            for k=0:1:$l(direct)-1 {
                s dir2 = $e(direct,((k+2)#4)+1,((k+2)#4)+1)
                s dir1 = $e(direct,k+1,k+1)
                s g1 = $get(uniqueNodes(i_"|"_j_"|"_dir1),0)
                s g2 = $get(uniqueNodes2(i_"|"_j_"|"_dir2),0)
                if (((g1+g2)=sum) && ($get(sum(i,j),0)=0)) {
                    do $I(count)
                    s sum(i,j)=1
                }
            }
        }
    }


    s sum = count
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

    s map = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s map($I(map)) = line
    }
    s start = ..findCharInMap(.map, "S")
    s end = ..findCharInMap(.map, "E")
    KILL pqueue
    s pqueue = 1
    s pqueue(1) = 1
    s pqueue(1,1) = $p(start,",",1)_"|"_$p(start,",",2)_"|"_"0|E|0"
    s sum = ..findShortestPath(.map,start,end,.uniqueNodes,.pqueue)
    
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
        s prevDir = $p(pqueue(it,it2),"|",4)

        KILL pqueue(it,it2)

        continue:($e(map(cX),cY,cY) = "#")
        if $GET(uniqueNodes(cX_"|"_cY_"|"_prevDir),-1) = -1 {
            s uniqueNodes(cX_"|"_cY_"|"_prevDir) = gn
        }
        continue:($Get(visited(cX,cY,prevDir),9999999) =1)

        s visited(cX,cY,prevDir) = 1

        #; continue:(gn > ans)

        if ((cX = endX) && (cY = endY)) {
            s:(ans > gn) ans = gn
            #; break
        }
        set nextPos = "-1,0,N|0,1,E|1,0,S|0,-1,W"
        for i=1:1:$l(nextPos,"|") {
            s nX = $p($p(nextPos,"|",i),",",1)
            s nY = $p($p(nextPos,"|",i),",",2)
            s dir = $p($p(nextPos,"|",i),",",3)

            continue:(((dir="N")&&(prevDir="S"))||((dir="S")&&(prevDir="N"))||((dir="E")&&(prevDir="W"))||((dir="W")&&(prevDir="E")))
            s newX = nX + cX
            s newY = nY + cY
            continue:((newX <= 1) || (newX >= map))
            continue:((newY <= 1) || (newY >= $l(map(newX))))
            continue:($e(map(newX),newY,newY) = "#")
            if '(dir = prevDir) {
                s curScore = gn + 1000
                s newQueueElement = cX_"|"_cY_"|"_curScore_"|"_dir
                S pqueue(curScore, $I(pqueue(curScore))) =  newQueueElement
            } else {
                s curScore = gn + 1
                s newQueueElement = newX_"|"_newY_"|"_curScore_"|"_dir
                S pqueue(curScore, $I(pqueue(curScore))) =  newQueueElement
            }
        }
    }
    return ans
}

}
