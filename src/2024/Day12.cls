Class aoc24.Day12 Extends aoc24.Base
{

Parameter InputFile = "24-day12.txt";

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
    s isTraversed = ""
    
    for i=1:1:map {
        for j=1:1:$l(map(i)) {
            KILL dfs
            if '$get(isTraversed(i,j)) {
                do ..CalculateAreaPerim(.map, .dfs,.isTraversed,0,0, i,j,$e(map(i),j,j) )
                s sum = sum + (dfs*..GetSides(.dfs))
            }

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

	s map = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s map($I(map)) = line
    }

    s isTraversed = ""
    
    for i=1:1:map {
        for j=1:1:$l(map(i)) {
            KILL dfs
            if '$get(isTraversed(i,j)) {
                do ..CalculateAreaPerim(.map, .dfs,.isTraversed,0,0, i,j,$e(map(i),j,j) )
                s sum = sum + (dfs*..GetParam(.dfs))
            }

        }
    }
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod CalculateAreaPerim(ByRef map, ByRef dfs, ByRef isTraversed, prevI, prevJ, curI, curJ, curChar)
{
    if (curI < 1) || (curI > map) {
        return
    }
    if (curJ < 1) || (curJ > $l(map(curI))) {
        return
    }
    return:'($e(map(curI),curJ,curJ)=curChar)

    if $get(isTraversed(curI,curJ))=1 {
        s dfs(prevI_","_prevJ) = dfs(prevI_","_prevJ) - 1
        return
    }
    s isTraversed(curI,curJ) = 1

    if (prevI = 0) && (prevJ=0) {
        s dfs(curI_","_curJ) = 4
    } else {
        s dfs(curI_","_curJ) = 3
        s dfs(prevI_","_prevJ) = dfs(prevI_","_prevJ) - 1
    }
    do $I(dfs)
    s next ="1,0|-1,0|0,1|0,-1"
    for i=1:1:$l(next,"|") {
        s newI = curI + $p($PIECE(next,"|",i),",",1)
        s newJ = curJ + $p($PIECE(next,"|",i),",",2)
        continue:((newI = prevI) && (newJ=prevJ))
        do ..CalculateAreaPerim(.map, .dfs,.isTraversed,curI,curJ, newI,newJ, curChar)
    }
    return
}

ClassMethod GetParam(ByRef dfs) As %Integer
{
    s sum = 0
    s it = ""
    for {
        s it=$o(dfs(it))
        q:(it="")
        s sum = sum + dfs(it)
    }
    return sum
}

ClassMethod GetSides(ByRef dfs) As %Integer
{
    s sum = 0
    s it = ""
    for {
        s it=$o(dfs(it))
        q:(it="")
        s i = $PIECE(it,",",1)
        s j = $PIECE(it,",",2)
        s input = "-1,0:0,-1:-1,-1|-1,0:0,1:-1,1|0,1:1,0:1,1|0,-1:1,0:1,-1"
        for idx=1:1:$l(input,"|"){
            s it2 = $PIECE(input,"|",idx)
            s ki1 = $p($PIECE(it2,":",1),",",1) + i
            s kj1 = $p($PIECE(it2,":",1),",",2) + j
            s ki2 = $p($PIECE(it2,":",2),",",1) + i
            s kj2 = $p($PIECE(it2,":",2),",",2) + j
            s ki3 = $p($PIECE(it2,":",3),",",1) + i
            s kj3 = $p($PIECE(it2,":",3),",",2) + j
            
            if (($get(dfs(ki1_","_kj1),-1)'=-1) && ($get(dfs(ki2_","_kj2),-1)'=-1)) {
                if ($get(dfs(ki3_","_kj3),-1)=-1) {
                    s sum = sum+1
                }
            } elseif (($get(dfs(ki1_","_kj1),-1)=-1) && ($get(dfs(ki2_","_kj2),-1)=-1)) {
                s sum = sum+1
            }
        }
        
    }
    return sum
}

}
