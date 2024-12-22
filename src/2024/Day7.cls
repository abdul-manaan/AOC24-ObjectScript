Class aoc24.Day7 Extends aoc24.Base
{

Parameter InputFile = "24-day7.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

    set equations = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        set answer = $piece(line,":",1)
        set equations($I(equations)) = answer

        for i=1:1:$LENGTH($PIECE(line,":",2)," ") {
            s num = $PIECE($PIECE(line,":",2)," ",i)
            if num="" {
                continue
            }
            //zw equations
            s equations(equations,$I(equations(equations,0))) = num
        }
        s c = ..ApplyOperatorsP2(.equations, equations, 0,1)
        if c {
            s sum = sum + equations(equations)
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

    set equations = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        set answer = $piece(line,":",1)
        set equations($I(equations)) = answer

        for i=1:1:$LENGTH($PIECE(line,":",2)," ") {
            s num = $PIECE($PIECE(line,":",2)," ",i)
            if num="" {
                continue
            }
            s equations(equations,$I(equations(equations,0))) = num
        }
        s c = ..ApplyOperators(.equations, equations, equations(equations,1),2)
        if c {
            s sum = sum + equations(equations)
        }
    }
    
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    
    return sum
}

ClassMethod ApplyOperators(ByRef equations, eqNum, curAns, nextOp) As %Integer
{
    if nextOp > equations(eqNum,0) {
        return curAns=equations(eqNum)
    } elseif curAns > equations(eqNum) {
        return 0
    }

    
    s ans1 = curAns * equations(eqNum,nextOp)
    s ans2 = curAns + equations(eqNum,nextOp)

    return ..ApplyOperators(.equations, eqNum, ans1, nextOp+1) || ..ApplyOperators(.equations, eqNum, ans2, nextOp+1)
}

ClassMethod ApplyOperatorsP2(ByRef equations, eqNum, curAns, nextOp) As %Integer
{
    //w " ",eqNum," ",curAns, " ",nextOp,!
    if nextOp > equations(eqNum,0) {
        return curAns=equations(eqNum)
    } elseif curAns > equations(eqNum) {
        return 0
    }

    s ans1=0, ans2=0, ans3=0

    // Concat Operator
    if nextOp > 1 {
        s ans1 = curAns_equations(eqNum,nextOp)
        s ans1 = ..ApplyOperatorsP2(.equations, eqNum,ans1,nextOp+1)
    }

    // MUltiplication
    s:(nextOp=1) curAns = 1
    s ans2 = curAns * equations(eqNum,nextOp)
    //s ans2 = 

    //Addition
    s:(nextOp=1) curAns = 0
    s ans3 = curAns + equations(eqNum,nextOp)
    
    return ans1 || ..ApplyOperatorsP2(.equations, eqNum, ans2, nextOp+1) || ..ApplyOperatorsP2(.equations, eqNum, ans3, nextOp+1)
}

}
