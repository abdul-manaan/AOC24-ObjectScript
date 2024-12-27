Class aoc24.Day6 Extends aoc24.Base
{

Parameter InputFile = "24-day6.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

    set curLineNo = 0
    set puzzleMap = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s curLineNo = curLineNo + 1
        s puzzleMap($I(puzzleMap)) = line
        if $l(line,"^") > 1 {
            s startPos = curLineNo
        }
    }

    // Find path that guard originally take
    // so that we can obstacle to only those positions that are in path of guard
    do ..SolvePuzzle(.puzzleMap, startPos)

    // Optimize map traversal
    s TOTALCOLS = $l(puzzleMap(1))
    for r=1:1:curLineNo {
        for c=1:1:TOTALCOLS {
            if ($EXTRACT(puzzleMap(r), c) = "0") {
                // Modify cell, check if stuck, and revert
                s $EXTRACT(puzzleMap(r), c) = "#"
                s stuck = ..AreWeStuck(.puzzleMap, startPos)
                set sum = sum + stuck
                s $EXTRACT(puzzleMap(r), c) = "0"
            }
        }
    }

    w "SUM is: "_sum, !
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

    set curLineNo = 0
    set puzzleMap = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s curLineNo = curLineNo + 1
        s puzzleMap($I(puzzleMap)) = line
        if $l(line,"^") > 1 {
            s startPos = curLineNo
        }
    }

    s sum = ..SolvePuzzle(.puzzleMap, startPos)
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod SolvePuzzle(ByRef puzzleMap, row, col = 0) As %Integer
{

    if col = 0 {
        s col = $FIND(puzzleMap(row),"^")-1
    }
    s rowDir = -1
    s colDir = 0
    s count = 1
    for {
        s newRow = row + rowDir
        s newCol = col + colDir 

        if (newRow > puzzleMap)||(newRow < 1) {
            QUIT
        }
        if (newCol > $l(puzzleMap(1)))||(newCol < 1) {
            QUIT
        }
        s newChar = $EXTRACT(puzzleMap(newRow),newCol, newCol)
        if newChar = "#" {
            if rowDir=-1,colDir=0 {
                s rowDir=0,colDir=1
            } elseif rowDir=0,colDir=1 {
                s rowDir=1,colDir=0
            } elseif rowDir=1,colDir=0 {
                s rowDir=0,colDir=-1
            } elseif rowDir=0,colDir=-1 {
                s rowDir=-1,colDir=0
            } 
            continue
        } elseif newChar = "." {
            //w count,!
            s count = count + 1
            s $EXTRACT(puzzleMap(newRow),newCol, newCol) = "0"
            s row = newRow
            s col = newCol
        } else {
            s row = newRow
            s col = newCol
        }
    }
    return count
}

/*
Checking if we are stuck:
- if we we visist same node again, 
- while coming from same direction, as we were visiting last time,
- it would means we ARE STUCK!
*/
ClassMethod AreWeStuck(ByRef puzzleMap, row, col = 0) As %Integer
{
    s weStuck = 0
    if col = 0 {
        s col = $FIND(puzzleMap(row), "^") - 1
    }

    s rowDir = -1
    s colDir = 0
    s visitedPositions = ""
    s TOTALROWS = $ORDER(puzzleMap(""), -1)
    s TOTALCOLS = $LENGTH(puzzleMap(1))
    for {
        // Calculate the next position
        s newRow = row + rowDir
        s newCol = col + colDir
        
        // Check if new position is out of bounds
        if (newRow > TOTALROWS) || (newRow < 1) || (newCol > TOTALCOLS) || (newCol < 1) {
            QUIT
        }
        
        s newChar = $EXTRACT(puzzleMap(newRow), newCol, newCol)

        // Handle wall (#): Change direction
        if newChar = "#" {
            if rowDir = -1, colDir = 0 {
                s rowDir = 0, colDir = 1
            } elseif rowDir = 0, colDir = 1 {
                s rowDir = 1, colDir = 0
            } elseif rowDir = 1, colDir = 0 {
                s rowDir = 0, colDir = -1
            } elseif rowDir = 0, colDir = -1 {
                s rowDir = -1, colDir = 0
            }
            continue
        }

        // Handle free space or any other character
        s row = newRow
        s col = newCol
        
        // Track visited positions
        s newDirection = $LISTBUILD(rowDir,colDir)

        // Check if position is visited too frequently
        if $LISTSAME($get(visitedPositions(newRow,newCol),$lb()), newDirection) {
            s weStuck = 1
            QUIT
        }
        s visitedPositions(newRow,newCol) = newDirection

    }

    return weStuck
}

}
