Class aoc24.Day17 Extends aoc24.Base
{

Parameter InputFile = "24-day17.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

	s program=""
	while 'stream.AtEnd {
		set line1=stream.ReadLine()
        set line2=stream.ReadLine()
        set line3=stream.ReadLine()

        s rA = $p(line1,": ",2)
        s rB = $p(line2,": ",2)
        s rC = $p(line3,": ",2)
        do stream.ReadLine()
        set line4 = stream.ReadLine()

        s program = $p(line4,": ",2)
    }

    s sum = ..pleaseSolveIt(program,$l(program),0)

   
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

    s program="",rA=0,rB=0,rC=0
	while 'stream.AtEnd {
		set line1=stream.ReadLine()
        set line2=stream.ReadLine()
        set line3=stream.ReadLine()

        s rA = $p(line1,": ",2)
        s rB = $p(line2,": ",2)
        s rC = $p(line3,": ",2)
        do stream.ReadLine()
        set line4 = stream.ReadLine()

        s program = $p(line4,": ",2)
    }

    s ans = ..RunProgram(program,rA,rB,rC)

   
    w "SUM is: "_ans,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return ans
}

ClassMethod operand(op, A, B, C)
{
    if (op < 4) {
        return op
    } elseif (op=4) {
        return A
    } elseif (op=5) {
        return B
    } elseif (op=6) {
        return C
    }
}

ClassMethod div(A, B) As %Integer
{
   
    s ans = A
    for i=1:1:B {
        s ans = ans / 2
        q:(ans < 1)
    }
    return ans\1.0
}

ClassMethod RunProgram(program, rA, rB, rC) As %String
{
    s ans = ""
    s i = 1
    for {
        s ip = $piece(program,",",i)
        s op = $piece(program,",",i+1)

        q:(ip="")

        if (ip=0) {
            s rA = ..div(rA , (..operand(op,rA,rB,rC)))
        } elseif (ip=1) {
            s rB = $zb(+rB,+op,6)
        } elseif (ip=2) {
            s rB = ..operand(+op,+rA,+rB,+rC)#8
        } elseif (ip=3) {
            if (rA'=0) {
                s i = op+1
                continue
            }  
        } elseif (ip=4) {
            s rB = $zb(rB,rC,6)
        } elseif (ip=5) {
            s ans = ans _ (..operand(op,rA,rB,rC)#8)_","
        } elseif (ip=6) {
            s rB = ..div(rA , (..operand(op,rA,rB,rC)))
        } elseif (ip=7) {
            s rC = ..div(rA , (..operand(op,rA,rB,rC)))
        }
        s i = i + 2
    }
    return $e(ans,1,*-1)
}

ClassMethod pleaseSolveIt(program, por, curr)
{
    /**
        I am going in Backward direction
        Given a Program X,xOP,Y,yOP
            we first try to find rA that can produce yOP only.
            this should be within 0-7 incl. range.

            Next, we move back one step, and try to find "Y,yOP"
            From some basic understanding/debugging,
                I know that Part1() generates 2-numbers output, when rA > 7
                I know that Part1() generates 3-numbers output, when rA > 63
                and so on/
            
            Using the above understanding,
                we run the program again 8-times trying to find 2nd match.
                and so on.
            
            At the end, we will have complete match!!!
            
        Question for thought: given an input, how many times at max rec will be called?
    */

    for i=0:1:7 {
        s newRA = (curr*8)+i
        s newOut = ..RunProgram(program,newRA,0,0)
        s ansThatIsSolved = $EXTRACT(program,por,*)
        return:(program=newOut) newRA

        if newOut = ansThatIsSolved {
            if por = 0 {
                return newRA
            } else {
                s result = ..pleaseSolveIt(program, por-2,newRA)
                if result'="-1" {
                    return result
                }
            }
        }
    }
    return "-1"
}

}
