Class aoc24.Day3 Extends aoc24.Base
{

Parameter InputFile = "24-day3.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0
    s shouldDo = 1
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s sum = sum + ..ExtractValidMulInstructions2(line,.shouldDo)
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
        s sum = sum + ..ExtractValidMulInstructions1(line)
    }
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod ExtractValidMulInstructions1(input) As %Integer
{
    SET result=0
    SET i=1
    
    FOR  {
        SET i=$FIND(input, "mul(", i) 
        QUIT:i=0
        SET endPos=$FIND(input, ")", i)
        IF (endPos > i) {
            SET content=$EXTRACT(input, i, endPos-2)
            IF $LENGTH(content, ",")=2 {
                SET num1=$PIECE(content, ",", 1)
                SET num2=$PIECE(content, ",", 2)
                IF (num1?1.3N) && (num2?1.3N) {
                    SET result=result+(num1*num2)
                }
            } 
        }
    }
    QUIT result
}

ClassMethod ExtractValidMulInstructions2(input, ByRef shouldDo) As %Integer
{
    SET result=0
    SET i=1
    FOR  {
        SET origI = i
        SET i=$FIND(input, "mul(", origI) 
        QUIT:i=0
        SET endPos=$FIND(input, ")", i)
        SET nextDoOffset = $FIND(input, "do()", origI)
        SET nextDontOffset = $FIND(input, "don't()", origI)
        if (nextDoOffset < i) && (nextDoOffset '= 0) {
            set i = nextDoOffset
            set shouldDo = 1
            continue
        }
        if (nextDontOffset < i) && (nextDontOffset '= 0) {
            set i = nextDontOffset
            set shouldDo = 0
            continue
        }
        IF (endPos > i) {
            SET content=$EXTRACT(input, i, endPos-2)
            IF $LENGTH(content, ",")=2 {
                SET num1=$PIECE(content, ",", 1)
                SET num2=$PIECE(content, ",", 2)
                IF (num1?1.3N) && (num2?1.3N) {
                    SET:(shouldDo=1) result=result+(num1*num2)
                }
            } 
        }
    }
    QUIT result
}

}
