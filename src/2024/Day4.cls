Class aoc24.Day4 Extends aoc24.Base
{

Parameter InputFile = "24-day4.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0
    set input = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s input($I(input)) = line
    }

    s sum = ..CalcHowManyXMAS(.input,2)
    
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
    set input = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s input($I(input)) = line
    }

    s sum = ..CalcHowManyXMAS(.input)
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod CalcHowManyXMAS(ByRef input, part = 1) As %Integer
{
    s sum = 0
    for ii=1:1:input {
        for jj=1:1:$LENGTH(input(ii)) {
            if (($EXTRACT(input(ii),jj,jj) = "X") && (part = 1)) {
                s sum = sum + ..CalcXMASAllDirections(.input, ii, jj)
            } elseif (($EXTRACT(input(ii),jj,jj) = "A") && (part = 2)){
                s sum = sum + ..CalcXMASAllDirectionsPart2(.input, ii, jj)
            }
        }
    }
    return sum
}

ClassMethod CalcXMASAllDirections(ByRef input, row, col)
{
    s sum = 0
    s directions = "-1,-1:-1,1:-1,0:1,-1:1,0:1,1:0,1:0,-1"
    for i=1:1:$LENGTH(directions,":") {
        s cords = $PIECE(directions,":",i)
        s xcord = $PIECE(cords,",",1)
        s ycord = $PIECE(cords,",",2)

        s toFind = "XMAS"
        s newRow = row
        s newCol = col
        s isMatched = 1
        for k=1:1:4 {
            if ((newRow <= 0) || (newRow > input)) {
                s isMatched = 0
                q
            }
            if ((newCol <= 0) || (newCol > $LENGTH(input(newRow)))) {
                s isMatched = 0
                q
            }
            if $EXTRACT(input(newRow),newCol,newCol)'=$EXTRACT(toFind,k,k) {
                s isMatched = 0
                q
            }
            s newRow = newRow+xcord
            s newCol = newCol+ycord
        }
        if isMatched {
            s sum = sum + 1
        }
    }
    return sum
}

ClassMethod CalcXMASAllDirectionsPart2(ByRef input, row, col)
{
    s sum = 0
    s directions = "-1,-1:-1,1:1,-1:1,1"
    s xmasString = ""
    for i=1:1:$LENGTH(directions,":") {
        s cords = $PIECE(directions,":",i)
        s xcord = $PIECE(cords,",",1)
        s ycord = $PIECE(cords,",",2)
        s toFind = "XMAS"
        s newRow = row + xcord
        s newCol = col + ycord
        
        if ((newRow <= 0) || (newRow > input)) {
            q
        }
        if ((newCol <= 0) || (newCol > $LENGTH(input(newRow)))) {
            q
        }
        s xmasString = xmasString_$EXTRACT(input(newRow),newCol,newCol)
    }

    if ((xmasString = "MMSS") || (xmasString = "MSMS") || (xmasString = "SSMM") || (xmasString = "SMSM") ) {
        return 1
    }

    return sum
}

}
