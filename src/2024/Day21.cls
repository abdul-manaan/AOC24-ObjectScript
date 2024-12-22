Class aoc24.Day21 Extends aoc24.Base
{

Parameter InputFile = "24-day21.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s sum = sum + ..SolvePart1or2(line,25)
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

	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s sum = sum + ..SolvePart1or2(line)
    }

    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

/*
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+
*/
ClassMethod GetPosition(num As %Integer) As %String
{
    // Define the mapping of keys to positions
    Set positions(7) = "1,1"
    Set positions(8) = "1,2"
    Set positions(9) = "1,3"
    Set positions(4) = "2,1"
    Set positions(5) = "2,2"
    Set positions(6) = "2,3"
    Set positions(1) = "3,1"
    Set positions(2) = "3,2"
    Set positions(3) = "3,3"
    Set positions(0) = "4,2"
    Set positions("A") = "4,3"

    // Return the position or an error message
    Quit $Get(positions(num), "Invalid input")
}

/**
    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
*/
ClassMethod GetDirectionPosition(dir As %String) As %String
{
    // Define the mapping of directions to positions
    Set directions("^") = "1,2"
    Set directions("A") = "1,3"
    Set directions("<") = "2,1"
    Set directions("v") = "2,2"
    Set directions(">") = "2,3"

    // Return the position or an error message
    Quit $Get(directions(dir), "Invalid input")
}

ClassMethod NumberToDirection(prevPos, newPos)
{
    s prev = ..GetPosition(prevPos)
    s next = ..GetPosition(newPos)

    s prevI = $p(prev,",",1)
    s prevJ = $p(prev,",",2)

    s nextI = $p(next,",",1)
    s nextJ = $p(next,",",2)

    // -> ^ <- v
    s diffI = nextI - prevI
    s diffJ = nextJ - prevJ

    s Horizontal = ""
    s Vertical = ""
    s ans = ""

    while (diffJ > 0) {
        s Horizontal = Horizontal _ ">"
        s diffJ = diffJ - 1
    }
    while (diffJ < 0) {
        s Horizontal = Horizontal _ "<"
        s diffJ = diffJ + 1
    }

    while (diffI < 0) {
        s Vertical = Vertical _ "^"
        s diffI = diffI + 1
    }
    

    while (diffI > 0) {
        s Vertical = Vertical _ "v"
        s diffI = diffI - 1
    }

    // The idea is to prefer < over ^ over v over >
    // But, we don't want to go to empty space.
    // So, the first 2 if/else makes sure we do not pass through
    // empty space.
    if ((prevI = 4) && (nextJ = 1)) { // {0,A} => {7,4,1}
        s ans = Vertical _ Horizontal
    } elseif((prevJ = 1) && (nextI = 4)){ // {7,4,1} => {0,A}
        s ans = Horizontal _ Vertical
    } elseif ((nextJ-prevJ) < 0) {
        s ans = Horizontal _ Vertical
    } else {
        s ans = Vertical _ Horizontal
    }

    return ans _ "A"
}

ClassMethod DirectionToDirection(prevPos, newPos)
{
    s prev = ..GetDirectionPosition(prevPos)
    s next = ..GetDirectionPosition(newPos)

    s prevI = $p(prev,",",1)
    s prevJ = $p(prev,",",2)

    s nextI = $p(next,",",1)
    s nextJ = $p(next,",",2)

    // -> v <- ^
    s diffI = nextI - prevI
    s diffJ = nextJ - prevJ

    s Horizontal = ""
    s Vertical = ""
    s ans = ""

    while (diffJ > 0) {
        s Horizontal = Horizontal _ ">"
        s diffJ = diffJ - 1
    }
    while (diffJ < 0) {
        s Horizontal = Horizontal _ "<"
        s diffJ = diffJ + 1
    }

    while (diffI < 0) {
        s Vertical = Vertical _ "^"
        s diffI = diffI + 1
    }
    

    while (diffI > 0) {
        s Vertical = Vertical _ "v"
        s diffI = diffI - 1
    }
    // The idea is to prefer < over ^ over v over >
    // But, we don't want to go to empty space.
    // So, the first 2 if/else makes sure we do not pass through
    // empty space.
    if ((prevI = 1) && (nextJ = 1)) { // {^,A} => {<}
        s ans = Vertical _ Horizontal
    } elseif((prevJ = 1) && (nextI = 1)){ //  {<} => {^,A}
        s ans = Horizontal _ Vertical
    } elseif ((nextJ-prevJ) < 0) {
        s ans = Horizontal _ Vertical
    } else {
        s ans = Vertical _ Horizontal
    }

    return ans _ "A"
}

ClassMethod SolvePart1or2(number, numberOfRobots = 2)
{
    s prev = "A"
    s robot = 0
    for i=1:1:$l(number) {
        s seq = ..NumberToDirection(prev,$e(number,i,i))
        do $I(robot(seq))
        s prev = $e(number,i,i)
    }

    for idx=1:1:numberOfRobots {
        KILL nextRobotSeq
        s nextRobotSeq = ""
        s it = ""
        for {
            s it = $o(robot(it))
            q:(it="")
            do ..SolveThisSeq(it,.nextRobotSeq,robot(it))
        }
        KILL robot
        merge robot = nextRobotSeq
    }

    s it = ""
    s sum = 0
    for {
        s it = $o(robot(it))
        q:(it = "")
        s sum = sum + ((robot(it)*+number)*$l(it))
    }
    
    return sum
}

ClassMethod SolveThisSeq(seq, ByRef SequenceCache, seqMultiplier)
{
    s prev = "A"
    for i=1:1:$l(seq) {
        s nextSeq = ..DirectionToDirection(prev, $e(seq,i,i))
        s SequenceCache(nextSeq) = $get(SequenceCache(nextSeq),0) + seqMultiplier
        s prev = $e(seq,i,i)
    } 
    Quit
}

}
