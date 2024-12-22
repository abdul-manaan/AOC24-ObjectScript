Class aoc24.Day10 Extends aoc24.Base
{

Parameter InputFile = "24-day10.txt";

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

    s sum = ..CalculateScore(.map,1)
    
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

    s sum = ..CalculateScore(.map)
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod CalculateScore(ByRef map, part2 = 0)
{
    s rows = map
    s cols = $LENGTH(map(1))

    s sum = 0
    for i=1:1:rows {
        for j=1:1:cols {
            s height = $EXTRACT(map(i),j,j)
            if height = 9 {
                s AllZeros = 0
                if part2=1 {
                    s curRoute = ""
                    do ..CanWeReachZero2(.map, i, j,.AllZeros, 10,curRoute)
                } else {
                    do ..CanWeReachZero(.map, i, j,.AllZeros, 10)
                }
                s sum = sum + AllZeros
                KILL AllZeros
            }
        }
    }
    return sum
}

ClassMethod CanWeReachZero(ByRef map, row, col, ByRef AllZeros, prevHeight)
{
    if (row > map) || (row < 1) {
        return
    }
    if (col > $l(map(1))) || (col < 1) {
        return
    }
    s curentHeight = $e(map(row),col,col)
    if (curentHeight '= (prevHeight-1)) {
        return
    }

    if curentHeight = 0 {
        if '$GET(AllZeros(row,col)) {
            do $I(AllZeros)
            s AllZeros(row,col) = 1
        }
        return
    } else {
        do ..CanWeReachZero(.map, row+1, col, .AllZeros, curentHeight)
        do ..CanWeReachZero(.map, row-1, col, .AllZeros, curentHeight)
        do ..CanWeReachZero(.map, row, col+1, .AllZeros, curentHeight)
        do ..CanWeReachZero(.map, row, col-1, .AllZeros, curentHeight)
    }
    return
}

ClassMethod CanWeReachZero2(ByRef map, row, col, ByRef AllZeros, prevHeight, curRoute)
{
    if (row > map) || (row < 1) {
        return
    }
    if (col > $l(map(1))) || (col < 1) {
        return
    }
    s curentHeight = $e(map(row),col,col)
    if (curentHeight '= (prevHeight-1)) {
        return
    }
    s curRoute = curRoute_"|"_row_"."_col
    if curentHeight = 0 {
        if '$GET(AllZeros(curRoute)) {
            do $I(AllZeros)
            s AllZeros(curRoute) = 1
        }
        return
    } else {
        do ..CanWeReachZero2(.map, row+1, col, .AllZeros, curentHeight,curRoute)
        do ..CanWeReachZero2(.map, row-1, col, .AllZeros, curentHeight,curRoute)
        do ..CanWeReachZero2(.map, row, col+1, .AllZeros, curentHeight,curRoute)
        do ..CanWeReachZero2(.map, row, col-1, .AllZeros, curentHeight,curRoute)
    }
    return
}

}
