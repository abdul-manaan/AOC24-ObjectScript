Class aoc24.Day8 Extends aoc24.Base
{

Parameter InputFile = "24-day8.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

    set inpuFrequencies = ""
    set rowIdx = 0
    s totalCols = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s rowIdx = rowIdx + 1
        for colIdx=1:1:$l(line) {
            s:'$get(totalCols) totalCols = $l(line)
            s charInLine = $EXTRACT(line,colIdx,colIdx)
            if (charInLine '= ".") {
                do $I(inpuFrequencies(charInLine))
                s inpuFrequencies(charInLine,inpuFrequencies(charInLine),rowIdx,colIdx) = charInLine
            }
        }
    
    }
    s inpuFrequencies = rowIdx
    
    s sum = ..CalculateUniqueAntiNodes2(.inpuFrequencies, totalCols)
    
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

    set inpuFrequencies = ""
    set rowIdx = 0
    s totalCols = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s rowIdx = rowIdx + 1
        for colIdx=1:1:$l(line) {
            s:'$get(totalCols) totalCols = $l(line)
            s charInLine = $EXTRACT(line,colIdx,colIdx)
            if (charInLine '= ".") {
                do $I(inpuFrequencies(charInLine))
                s inpuFrequencies(charInLine,inpuFrequencies(charInLine),rowIdx,colIdx) = charInLine
            }
        }
    
    }
    s inpuFrequencies = rowIdx
    
    s sum = ..CalculateUniqueAntiNodes(.inpuFrequencies, totalCols)
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod CalculateUniqueAntiNodes(ByRef inpuFrequencies, totalCols) As %Integer
{
    s curChar = ""
    s foundInode = 0
    for {
        s curChar = $ORDER(inpuFrequencies(curChar))
        q:(curChar = "")

        for i=1:1:(inpuFrequencies(curChar)-1) {
            for j = i+1:1:inpuFrequencies(curChar) {
                s row1 = $ORDER(inpuFrequencies(curChar,i,""))
                s col1 = $ORDER(inpuFrequencies(curChar,i,row1,""))
                s row2 = $ORDER(inpuFrequencies(curChar,j,""))
                s col2 = $ORDER(inpuFrequencies(curChar,j,row2,""))

                s rowDiff = $zabs(row1-row2)
                s colDiff = $zabs(col1-col2)

                s newR1="",newR2="",newC1="",newC2 = ""
                if row1 < row2 {
                    s newR1 = row1 - rowDiff
                    s newR2 = row2 + rowDiff
                } else {
                    s newR1 = row1 + rowDiff
                    s newR2 = row2 - rowDiff
                }
                if col1 < col2 {
                    s newC1 = col1 - colDiff
                    s newC2 = col2 + colDiff
                } else {
                    s newC1 = col1 + colDiff
                    s newC2 = col2 - colDiff
                }

                if ..IsInBounds(newR1,newC1,.inpuFrequencies, totalCols) {
                    
                    if '$Get(foundInode(newR1,newC1),0) {
                        s foundInode(newR1, newC1) = 1
                        do $I(foundInode)
                    }
                }
                if ..IsInBounds(newR2,newC2,.inpuFrequencies, totalCols) {
                    
                    if '$Get(foundInode(newR2,newC2),0) {
                        s foundInode(newR2, newC2) = 1
                        do $I(foundInode)
                    }
                }
            }
        }
    }
    #; zw foundInode
    return foundInode
}

ClassMethod CalculateUniqueAntiNodes2(ByRef inpuFrequencies, totalCols) As %Integer
{
    s curChar = ""
    s foundInode = 0
    for {
        s curChar = $ORDER(inpuFrequencies(curChar))
        q:(curChar = "")

        for i=1:1:(inpuFrequencies(curChar)-1) {
            for j = i+1:1:inpuFrequencies(curChar) {
                s row1 = $ORDER(inpuFrequencies(curChar,i,""))
                s col1 = $ORDER(inpuFrequencies(curChar,i,row1,""))
                s row2 = $ORDER(inpuFrequencies(curChar,j,""))
                s col2 = $ORDER(inpuFrequencies(curChar,j,row2,""))

                s rowDiff = $zabs(row1-row2)
                s colDiff = $zabs(col1-col2)

                s newR1="",newC1=""
                s newR1 = row1
                s newC1 = col1
                for {
                    
                    if '$Get(foundInode(newR1,newC1),0) {
                        s foundInode(newR1, newC1) = 1
                        do $I(foundInode)
                    }

                    if row1 < row2 {
                        s newR1 = newR1 - rowDiff
                    } else {
                        s newR1 = newR1 + rowDiff
                    }
                    if col1 < col2 {
                        s newC1 = newC1 - colDiff
                    } else {
                        s newC1 = newC1 + colDiff
                    }
                    q:((newR1 < 1) || (newR1 > inpuFrequencies))
                    q:((newC1 < 1) || (newC1 > totalCols))         
                }
                s newR1 = row2
                s newC1 = col2
                for {
                    
                    if '$Get(foundInode(newR1,newC1),0) {
                        s foundInode(newR1, newC1) = 1
                        do $I(foundInode)
                    }

                    if row1 < row2 {
                        s newR1 = newR1 + rowDiff
                    } else {
                        s newR1 = newR1 - rowDiff
                    }
                    if col1 < col2 {
                        s newC1 = newC1 + colDiff
                    } else {
                        s newC1 = newC1 - colDiff
                    }
                    q:((newR1 < 1) || (newR1 > inpuFrequencies))
                    q:((newC1 < 1) || (newC1 > totalCols))         
                }
            }
        }
    }
    #; zw foundInode
    return foundInode
}

ClassMethod IsInBounds(row, col, ByRef inpuFrequencies, totalCols)
{
    if (row < 1) || (row > inpuFrequencies) {
        return 0
    }
    if (col < 1) || (col > totalCols) {
        return 0
    }
    return 1
}

}
