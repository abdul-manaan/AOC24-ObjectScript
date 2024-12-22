Class aoc24.Day9 Extends aoc24.Base
{

Parameter InputFile = "24-day9.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

    set input = -1
    set fileID = -1
    set inputStats = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        
        for idx=1:2:$l(line) {
            do $I(fileID)
            s fileLen = $EXTRACT(line,idx,idx)
            s freeBlk = $EXTRACT(line,idx+1,idx+1)
            s inputStats("FileL",fileID) = fileLen
            s inputStats("FileL",fileID,"StartID") = input+1
            s inputStats("FileL",fileID,"EndID") = input+fileLen
            for i=1:1:fileLen {
                s input($I(input)) = fileID 
            }
            
            s inputStats("FreeB",input+1) = freeBlk
            for i=1:1:freeBlk {
                s input($I(input)) = "." 
            }
        }
    }
    
    do ..MoveFilesToLeft2(.input,.inputStats,fileID) 

    set sum = ..CalculateChecksum(.input)
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

    set input = -1
    set fileID = -1
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        
        for idx=1:2:$l(line) {
            do $I(fileID)
            s fileLen = $EXTRACT(line,idx,idx)
            s freeBlk = $EXTRACT(line,idx+1,idx+1)
            for i=1:1:fileLen {
                s input($I(input)) = fileID 
            }
            for i=1:1:freeBlk {
                s input($I(input)) = "." 
            }
        }
    }
    
    do ..MoveFilesToLeft(.input) 
    set sum = ..CalculateChecksum(.input)
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod MoveFilesToLeft2(ByRef input, ByRef inputStats, maxFileID)
{
    s i = 0
    s fileID = maxFileID
    for {
        q:(fileID < 0)

        s needSpace = inputStats("FileL",fileID)

        s freeBlockID = 0
        for {
            s freeBlockID = $o(inputStats("FreeB",freeBlockID))
            q:(freeBlockID = "")
            q:(freeBlockID > inputStats("FileL",fileID,"StartID"))
            if (inputStats("FreeB",freeBlockID) >= needSpace) {
                quit
            }
        }
        if freeBlockID <inputStats("FileL",fileID,"StartID")  {
            s inputStats("FreeB",freeBlockID+needSpace) = inputStats("FreeB",freeBlockID) - needSpace
            KILL inputStats("FreeB",freeBlockID)

            for i=inputStats("FileL",fileID,"StartID"):1:inputStats("FileL",fileID,"EndID") {
                s input(freeBlockID) = fileID
                s input(i) = "."
                do $I(freeBlockID)
            }
        }
        
        s fileID = fileID - 1
    }
    return 0
}

ClassMethod MoveFilesToLeft(ByRef input)
{
    s i = 0
    s j = $Order(input(""),-1)
    for {
        q:(i >= j)
        if input(i)'="." {
            s i = i+1
            continue
        }
        if input(j)="." {
            s j = j -1
            continue
        }
        s input(i) = input(j)
        s input(j) = "."
        s i=i+1
        s j=j-1
    }
    return 0
}

ClassMethod CalculateChecksum(ByRef input) As %Integer
{
    s idx= ""
    s sum = 0
    for {
        s idx = $order(input(idx))
        q:(idx="")
        s sum = sum + (idx*input(idx))
    }
    return sum
}

}
