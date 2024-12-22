Class aoc24.Day15 Extends aoc24.Base
{

Parameter InputFile = "24-day15-test1.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

	set map = 0
    s AreWeReadingMap = 1
    s robotMoves = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()

        if line="" {
            s AreWeReadingMap = 0
            continue
        }

        if AreWeReadingMap {
            s map($I(map)) = line
        } else {
            s robotMoves = robotMoves_line
        }
    }

    do ..MakeNewMap(.map,.newMap)

    do ..MoveRobot(.newMap,robotMoves,1)
    s sum = ..CalculateGPSCoord(.newMap)
   
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

    set map = 0
    s AreWeReadingMap = 1
    s robotMoves = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()

        if line="" {
            s AreWeReadingMap = 0
            continue
        }

        if AreWeReadingMap {
            s map($I(map)) = line
        } else {
            s robotMoves = robotMoves_line
        }
    }

    do ..MoveRobot(.map,robotMoves)
    s sum = ..CalculateGPSCoord(.map)
   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod MoveRobot(ByRef map, moves As %String, ispart2 = 0)
{
    s robotPos = ..GetRobotPos(.map)
    for i=1:1:$l(moves) {
        s move = $e(moves,i,i)
        continue:(move=" ")
        if ispart2 {
            s robotPos = ..MakeASingleMove2(.map, robotPos, move)
        } else {
            s robotPos = ..MakeASingleMove(.map, robotPos, move)
        }
    }
}

ClassMethod MakeASingleMove(ByRef map, robotPos, move)
{
    s robotPosX = $p(robotPos,",",1)
    s robotPosY = $p(robotPos,",",2)

    if move="^" { // X--, Y remain same
        s newX = robotPosX
        s newY = robotPosY
        for {
            s newX = newX - 1
            quit:(newX <= 1)
            quit:($e(map(newX),newY,newY)="#")
            if $e(map(newX),newY,newY) = "." {
                quit
            }
        }
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),newY,newY) = "O"
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s $e(map(robotPosX-1),newY,newY) = "@"
            s robotPosX = robotPosX-1
            s robotPosY = newY 
        }
        return robotPosX_","_robotPosY
    } elseif move="v" { // X++, Y remain same
        s newX = robotPosX
        s newY = robotPosY
        for {
            s newX = newX + 1
            quit:(newX >= map)
            quit:($e(map(newX),newY,newY)="#")
            if $e(map(newX),newY,newY) = "." {
                quit
            }
        }
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),newY,newY) = "O"
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s $e(map(robotPosX+1),newY,newY) = "@"
            s robotPosX = robotPosX+1
            s robotPosY = newY 
        }
        return robotPosX_","_robotPosY
    } elseif move="<" { // X, Y-- remain same
        s newX = robotPosX
        s newY = robotPosY
        for {
            s newY = newY - 1
            quit:(newY <= 1)
            quit:($e(map(newX),newY,newY)="#")
            if $e(map(newX),newY,newY) = "." {
                quit
            }
        }
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),newY,newY) = "O"
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s $e(map(robotPosX),robotPosY - 1,robotPosY - 1) = "@"
            s robotPosX = robotPosX
            s robotPosY = robotPosY - 1 
        }
        return robotPosX_","_robotPosY
    }elseif move=">" { // X, Y++ remain same
        s newX = robotPosX
        s newY = robotPosY
        for {
            s newY = newY + 1
            quit:(newY >= $l(map(1)))
            quit:($e(map(newX),newY,newY)="#")
            if $e(map(newX),newY,newY) = "." {
                quit
            }
        }
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),newY,newY) = "O"
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s $e(map(robotPosX),robotPosY + 1,robotPosY + 1) = "@"
            s robotPosX = robotPosX
            s robotPosY = robotPosY + 1 
        }
        return robotPosX_","_robotPosY
    }
}

ClassMethod GetRobotPos(ByRef map) As %String
{
    for i=1:1:map {
        for j=1:1:$l(map(i)) {
            if $e(map(i),j,j)="@" {
                return i_","_j 
            }
        }
    }
    w "Could not find robot",!!!
    return "0,0"
}

ClassMethod CalculateGPSCoord(ByRef map) As %Integer
{
    s sum = 0
    for i=1:1:map {
        for j=1:1:$l(map(i)) {
            if $e(map(i),j,j) = "O" {
                s sum = sum + ((100*(i-1)) + (j-1))
            } elseif $e(map(i),j,j) = "[" {
                s sum = sum + ((100*(i-1)) + (j-1))
            }
        }
    }
    return sum
}

ClassMethod MakeNewMap(ByRef map, ByRef newMap)
{
    s newMap = map
    for i=1:1:map {
        s newMap(i) = ""
        for j=1:1:$l(map(i)) {
            s pos = $e(map(i),j,j)
            if pos = "#" {
                s newMap(i)= newMap(i)_"##"
            } elseif pos = "O" {
                s newMap(i)= newMap(i)_"[]"
            } elseif pos = "." {
                s newMap(i)= newMap(i)_".."
            } elseif pos = "@" {
                s newMap(i)= newMap(i)_"@."
            }
        }
    }
}

ClassMethod MakeASingleMove2(ByRef map, robotPos, move) As %String
{
    s robotPosX = $p(robotPos,",",1)
    s robotPosY = $p(robotPos,",",2)

    if move="<" { // X, Y-- remain same
        s newX = robotPosX
        s newY = robotPosY
        for {
            s newY = newY - 1
            quit:(newY <= 1)
            quit:($e(map(newX),newY,newY)="#")
            if $e(map(newX),newY,newY) = "." {
                quit
            }
        }
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),newY, robotPosY-1) = $e(map(newX),newY+1, robotPosY)
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s robotPosX = robotPosX
            s robotPosY = robotPosY - 1 
        }
        return robotPosX_","_robotPosY
    }elseif move=">" { // X, Y++ remain same
        s newX = robotPosX
        s newY = robotPosY
        for {
            s newY = newY + 1
            quit:(newY >= $l(map(1)))
            quit:($e(map(newX),newY,newY)="#")
            if $e(map(newX),newY,newY) = "." {
                quit
            }
        }
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),robotPosY+1,newY) = $e(map(newX),robotPosY,newY-1)
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s robotPosX = robotPosX
            s robotPosY = robotPosY + 1 
        }
        return robotPosX_","_robotPosY
    } elseif move="^" {
        s newX = robotPosX -1
        s newY = robotPosY
        quit:(newX <= 1 ) robotPosX_","_robotPosY
        quit:($e(map(newX),newY,newY)="#") robotPosX_","_robotPosY
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),newY,newY) = "@"
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s robotPosX = newX
        } elseif ($e(map(newX),newY,newY)="[") {
            s isMoved = ..MoveBlockUp(.map,newX,newY)
            if isMoved {
                s $e(map(newX),newY,newY) = "@"
                s $e(map(robotPosX),robotPosY,robotPosY) = "."
                s robotPosX = newX
                s robotPosY = newY
            }
        } elseif ($e(map(newX),newY,newY)="]") {
            s isMoved = ..MoveBlockUp(.map,newX,newY-1)
            if isMoved {
                s $e(map(newX),newY,newY) = "@"
                s $e(map(robotPosX),robotPosY,robotPosY) = "."
                s robotPosX = newX
                s robotPosY = newY
            }
        } 

    } elseif move="v" {
        s newX = robotPosX + 1
        s newY = robotPosY
        quit:(newX >= map ) robotPosX_","_robotPosY
        quit:($e(map(newX),newY,newY)="#") robotPosX_","_robotPosY
        if ($e(map(newX),newY,newY)=".") {
            s $e(map(newX),newY,newY) = "@"
            s $e(map(robotPosX),robotPosY,robotPosY) = "."
            s robotPosX = newX
        } elseif ($e(map(newX),newY,newY)="[") {
            s isMoved = ..MoveBlockDown(.map,newX,newY)
            if isMoved {
                s $e(map(newX),newY,newY) = "@"
                s $e(map(robotPosX),robotPosY,robotPosY) = "."
                s robotPosX = newX
                s robotPosY = newY
            }
        } elseif ($e(map(newX),newY,newY)="]") {
            s isMoved = ..MoveBlockDown(.map,newX,newY-1)
            if isMoved {
                s $e(map(newX),newY,newY) = "@"
                s $e(map(robotPosX),robotPosY,robotPosY) = "."
                s robotPosX = newX
                s robotPosY = newY
            }
        } 

    }
    return robotPosX_","_robotPosY
}

ClassMethod MoveBlockUp(ByRef map, posX, posY)
{
    s newPosX = posX -1
    s newPosY = posY
    return:(newPosX <= 1) 0
    return:($e(map(newPosX),newPosY,newPosY) = "#") 0
    return:($e(map(newPosX),newPosY+1,newPosY+1) = "#") 0 

    s aboveBoxes = $e(map(newPosX),newPosY,newPosY+1)
    if (aboveBoxes = "..") {
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    } elseif (aboveBoxes = "[]") {
        s canWeMoveThese = ..MoveBlockUp(.map,newPosX,newPosY)
        return:(canWeMoveThese=0) 0
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    } elseif (aboveBoxes = "][") {
        s canWeMoveThese1 = ..CanWeMoveBlockUp(.map,newPosX,newPosY-1)
        s canWeMoveThese2 = ..CanWeMoveBlockUp(.map,newPosX,newPosY+1)
        if (canWeMoveThese1 && canWeMoveThese2) {
            s canWeMoveThese = ..MoveBlockUp(.map,newPosX,newPosY-1)
            s canWeMoveThese = ..MoveBlockUp(.map,newPosX,newPosY+1)
            s $e(map(newPosX),newPosY,newPosY+1) = "[]"
            s $e(map(posX),posY,posY+1) = ".."
            return 1
        } else {
            return 0
        }
    } elseif (aboveBoxes = ".[") {
        s canWeMoveThese = ..MoveBlockUp(.map,newPosX,newPosY+1)
        return:(canWeMoveThese=0) 0
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    } elseif (aboveBoxes = "].") {
        s canWeMoveThese = ..MoveBlockUp(.map,newPosX,newPosY-1)
        return:(canWeMoveThese=0) 0
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    }
    return 0
}

ClassMethod CanWeMoveBlockUp(ByRef map, posX, posY)
{
    s newPosX = posX -1
    s newPosY = posY
    return:(newPosX <= 1) 0
    return:($e(map(newPosX),newPosY,newPosY) = "#") 0
    return:($e(map(newPosX),newPosY+1,newPosY+1) = "#") 0 

    s aboveBoxes = $e(map(newPosX),newPosY,newPosY+1)
    if (aboveBoxes = "..") {
        return 1
    } elseif (aboveBoxes = "[]") {
        return ..CanWeMoveBlockUp(.map,newPosX,newPosY)
    } elseif (aboveBoxes = "][") {
        s canWeMoveThese1 = ..CanWeMoveBlockUp(.map,newPosX,newPosY-1)
        s canWeMoveThese2 = ..CanWeMoveBlockUp(.map,newPosX,newPosY+1)
        if (canWeMoveThese1 && canWeMoveThese2) {
            return 1
        } else {
            return 0
        }
    } elseif (aboveBoxes = ".[") {
        return ..CanWeMoveBlockUp(.map,newPosX,newPosY+1)
    } elseif (aboveBoxes = "].") {
        return ..CanWeMoveBlockUp(.map,newPosX,newPosY-1)
    }
    return 0
}

ClassMethod MoveBlockDown(ByRef map, posX, posY)
{
    s newPosX = posX +1
    s newPosY = posY
    return:(newPosX >= map) 0
    return:($e(map(newPosX),newPosY,newPosY) = "#") 0
    return:($e(map(newPosX),newPosY+1,newPosY+1) = "#") 0 

    s aboveBoxes = $e(map(newPosX),newPosY,newPosY+1)
    if (aboveBoxes = "..") {
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    } elseif (aboveBoxes = "[]") {
        s canWeMoveThese = ..MoveBlockDown(.map,newPosX,newPosY)
        return:(canWeMoveThese=0) 0
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    } elseif (aboveBoxes = "][") {
        s canWeMoveThese1 = ..CanWeMoveBlockDown(.map,newPosX,newPosY-1)
        s canWeMoveThese2 = ..CanWeMoveBlockDown(.map,newPosX,newPosY+1)
        if (canWeMoveThese1 && canWeMoveThese2) {
            s canWeMoveThese = ..MoveBlockDown(.map,newPosX,newPosY-1)
            s canWeMoveThese = ..MoveBlockDown(.map,newPosX,newPosY+1)
            s $e(map(newPosX),newPosY,newPosY+1) = "[]"
            s $e(map(posX),posY,posY+1) = ".."
            return 1
        } else {
            return 0
        }
    } elseif (aboveBoxes = ".[") {
        s canWeMoveThese = ..MoveBlockDown(.map,newPosX,newPosY+1)
        return:(canWeMoveThese=0) 0
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    } elseif (aboveBoxes = "].") {
        s canWeMoveThese = ..MoveBlockDown(.map,newPosX,newPosY-1)
        return:(canWeMoveThese=0) 0
        s $e(map(newPosX),newPosY,newPosY+1) = "[]"
        s $e(map(posX),posY,posY+1) = ".."
        return 1
    }
    return 0
}

ClassMethod CanWeMoveBlockDown(ByRef map, posX, posY)
{
    s newPosX = posX + 1
    s newPosY = posY
    return:(newPosX >= map) 0
    return:($e(map(newPosX),newPosY,newPosY) = "#") 0
    return:($e(map(newPosX),newPosY+1,newPosY+1) = "#") 0 

    s aboveBoxes = $e(map(newPosX),newPosY,newPosY+1)
    if (aboveBoxes = "..") {
        return 1
    } elseif (aboveBoxes = "[]") {
        return ..CanWeMoveBlockDown(.map,newPosX,newPosY)
    } elseif (aboveBoxes = "][") {
        s canWeMoveThese1 = ..CanWeMoveBlockDown(.map,newPosX,newPosY-1)
        s canWeMoveThese2 = ..CanWeMoveBlockDown(.map,newPosX,newPosY+1)
        if (canWeMoveThese1 && canWeMoveThese2) {
            return 1
        } else {
            return 0
        }
    } elseif (aboveBoxes = ".[") {
        return ..CanWeMoveBlockDown(.map,newPosX,newPosY+1)
    } elseif (aboveBoxes = "].") {
        return ..CanWeMoveBlockDown(.map,newPosX,newPosY-1)
    }
    return 0
}

}
