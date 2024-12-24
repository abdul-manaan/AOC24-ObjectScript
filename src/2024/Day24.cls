Class aoc24.Day24 Extends aoc24.Base
{

Parameter InputFile = "24-day24-test.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream = ..GetInput(filename)

	s inputs = 0
    s gates = 0
    s XORGate = 0
    s ANDGate = 0
    s ORGate = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")
        if $l(line,":") > 1 {
            s inputs($p(line,":",1)) = +$zstrip($p(line,": ",2),"*P")
        } else {
            s gates($I(gates),$p(line," ",1),$p(line," ",3),$p(line," ",2)) = $p(line," -> ",2)
            if $p(line," ",2)= "XOR" {
                s XORGate($p(line," ",1),$p(line," ",3)) = $p(line," -> ",2)
                s XORGate($p(line," ",3),$p(line," ",1)) = $p(line," -> ",2)
            } elseif $p(line," ",2)= "AND" {
                s ANDGate($p(line," ",1),$p(line," ",3)) = $p(line," -> ",2)
                s ANDGate($p(line," ",3),$p(line," ",1)) = $p(line," -> ",2)
            } elseif $p(line," ",2)= "OR" {
                s ORGate($p(line," ",1),$p(line," ",3)) = $p(line," -> ",2)
                s ORGate($p(line," ",3),$p(line," ",1)) = $p(line," -> ",2)
            }
        }
    }
    s sum= ..Part2BruteForce(.gates,.inputs,.ANDGate,.XORGate,.ORGate)

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

    s inputs = 0
    s gates = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")
        if $l(line,":") > 1 {
            s inputs($p(line,":",1)) = +$zstrip($p(line,": ",2),"*P")
        } else {
            s gates($I(gates),$p(line," ",1),$p(line," ",3),$p(line," ",2)) = $p(line," -> ",2)
        }
    }

    s output = 0
    do ..ApplyGates(.gates,.inputs,.output)
    s sum = ..ConvertBitsToNumber(.output,"z")
   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    
    return sum
}

ClassMethod ApplyGates(ByRef gates, ByRef inputs, ByRef output)
{
    for {
        s gatesCalcInThisCycle = 0
        for i=1:1:gates {
            s op1 = $o(gates(i,""))
            continue:(op1="")

            s op2 = $o(gates(i,op1,""))
            continue:(op2="")

            s opr = $o(gates(i,op1,op2,""))
            continue:(opr="")

            s res = $get(gates(i,op1,op2,opr),"")
            continue:(res="")

            continue:($GET(inputs(op1),-1) = -1)
            continue:($GET(inputs(op2),-1) = -1)

            if $GET(output(res),-1) = -1 {
                s output(res) = ..ApplyBooleanOp(inputs(op1),inputs(op2),opr)
                s inputs(res) = output(res)
                do $I(gatesCalcInThisCycle)
            }
        }
        q:(gatesCalcInThisCycle=0)
    }
    return
}

ClassMethod ApplyBooleanOp(op1, op2, op3)
{
    if op3="AND" {
        return $ZB(op1,op2,1)
    } elseif op3="XOR" {
        return $ZB(op1,op2,6)
    } elseif op3="OR" {
        return $ZB(op1,op2,7)
    }
    return -1
}

ClassMethod ConvertBitsToNumber(ByRef output, whichGates)
{
    s it = whichGates
    s NextMultiplier = 1
    s sum = 0
    for {
        s it = $o(output(it))
        q:(it="")
        q:($e(it,1,1)'=whichGates)
        s sum = (output(it)*NextMultiplier) + sum
        s NextMultiplier = NextMultiplier*2
    }
    return sum
}

ClassMethod findRelatedOutputGates(g1, g2, op, ByRef ANDGate, ByRef XORGate, ByRef ORGate)
{

    if op="XOR" {
        return XORGate(g1,g2)
    } if op="OR" {
        return ORGate(g1,g2)
    } if op="AND" {
        return ANDGate(g1,g2)
    } 
    return "EMPTY"
}

ClassMethod findRelatedInputGates(outputGate, ByRef gates, ByRef binOp = "")
{
    s relatedGates = ""
    s binOp = ""
    for i=1:1:gates {
        s op1 = $o(gates(i,""))
        s op2 = $o(gates(i,op1,""))
        s opr = $o(gates(i,op1,op2,""))
        s res = $get(gates(i,op1,op2,opr),"")

        if (res=outputGate) {
            s binOp = opr
            return op1 _ "," _ op2
        }
    }
    return relatedGates
}

// zN = [xN ^ yN] ^ [ [xN-1 & yN-1] OR [gates of zN-1 w/ AND]]

ClassMethod Part2BruteForce(ByRef gates, ByRef inputs, ByRef ANDGate, ByRef XORGate, ByRef ORGate, ByRef needToBeSwapped) As %String
{
    s prevXGate = "x00"
    s prevYGate = "y00"
    s prevZGate = "z00"

    s needToBeSwapped = ""
    for iter=1:1 {
        s gateNum = iter
        if gateNum < 10 {
            s gateNum = "0"_iter
        }
        s xGate = "x"_gateNum
        s yGate = "y"_gateNum
        s zGate = "z"_gateNum

        s XOROutput = $get(XORGate(xGate,yGate),"")
        quit:(XOROutput="")
        s zNInputs = ..findRelatedInputGates(zGate,.gates,.zOPR)
        s zN1 = $p(zNInputs,",",1)
        s zN2 = $p(zNInputs,",",2)
       
        s prevXYANDGate = $get(ANDGate(prevXGate,prevYGate),"")
        s prevZIGates = ..findRelatedInputGates(prevZGate,.gates,.prevZOPR)
        s prevZN1 = $p(prevZIGates,",",1)
        s prevZN2 = $p(prevZIGates,",",2)
        s prevZInANDGate = $get(ANDGate(prevZN1,prevZN2),"")
        if prevZInANDGate = "" {
            s prevZInANDGate = "EMPTY"
        }

        s eqPart2 = $get(ORGate(prevXYANDGate,prevZInANDGate),"")
        if eqPart2 = "" {
            s eqPart2 = "EMPTY"
        }

        s prevXGate = xGate
        s prevYGate = yGate
        s prevZGate = zGate

        
        // If zOPR '= XOR this is wrong!
        if zOPR '= "XOR" {
            s needToBeSwapped(zGate) = 1
            s needToBeSwapped(..findRelatedOutputGates(eqPart2,XOROutput,"XOR",.ANDGate,.XORGate,.ORGate))= 1
        } elseif ((zN1 '= XOROutput) && (zN2 '= XOROutput)) {
            if zN1=eqPart2 {
                s needToBeSwapped(zN2) = 1
            } else {
                s needToBeSwapped(zN1) = 1
            }
            s needToBeSwapped(XOROutput) = 1

        } 
    }
    s it = ""
    s ans = ""
    for {
        s it=$o(needToBeSwapped(it))
        q:(it="")
        s ans = ans_","_it
    }
    return $e(ans,2,*)
}

ClassMethod isNextZFine(gateNum, ByRef gates, ByRef ANDGate, ByRef XORGate, ByRef ORGate)
{
    return:(gateNum < 2) 1
    s nextGN = gateNum + 1
    if nextGN < 10 {
        s nextGN = "0"_nextGN
    }
    if gateNum < 10 {
        s gateNum = "0"_gateNum
    }
    s xGate = "x"_nextGN
    s yGate = "y"_nextGN
    s zGate = "z"_nextGN

    s prevXGate = "x"_gateNum
    s prevYGate = "y"_gateNum
    s prevZGate = "z"_gateNum

    s XOROutput = $get(XORGate(xGate,yGate),"")
    s prevXYANDGate = $get(ANDGate(prevXGate,prevYGate),"")
    s zNInputs = ..findRelatedInputGates(zGate,.gates)
    s prevZIGates = ..findRelatedInputGates(prevZGate,.gates)
    
    return:(prevXYANDGate = "") 0
    
    s zN1 = $p(zNInputs,",",1)
    s zN2 = $p(zNInputs,",",2)
    s prevZN1 = $p(prevZIGates,",",1)
    s prevZN2 = $p(prevZIGates,",",2)

    s prevZInANDGate = $get(ANDGate(prevZN1,prevZN2),"")
    return:(prevZInANDGate = "") 0

    s eqPart2 = $get(ORGate(prevXYANDGate,prevZInANDGate),"")
    return:(eqPart2 = "") 0

    return:((zN1 '= eqPart2) && (zN2 '= eqPart2)) 0
    return:((zN1 '= XOROutput) && (zN2 '= XOROutput)) 0
    return 1
}

}
