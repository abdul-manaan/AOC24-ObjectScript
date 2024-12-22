Class aoc24.Day13 Extends aoc24.Base
{

Parameter InputFile = "24-day13.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

	while 'stream.AtEnd {
		set line1 = stream.ReadLine()
        continue:(line1="")

        set line2 = stream.ReadLine()
        set line3 = stream.ReadLine()
        s Ax = $p($p($P(line1,"Button A:",2),",",1),"+",2)
        s Bx = $p($p($P(line2,"Button B:",2),",",1),"+",2)
        s Ay = $p($p($P(line1,"Button A:",2),",",2),"+",2)
        s By = $p($p($P(line2,"Button B:",2),",",2),"+",2)

        s Px = $p($p($P(line3,"Prize:",2),",",1),"=",2) + 10000000000000
        s Py = $p($p($P(line3,"Prize:",2),",",2),"=",2) + 10000000000000

        s sum = sum + ..SolveSystemEq(Ax,Bx,Px, Ay,By,Py)

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
		set line1 = stream.ReadLine()
        continue:(line1="")

        set line2 = stream.ReadLine()
        set line3 = stream.ReadLine()
        s Ax = $p($p($P(line1,"Button A:",2),",",1),"+",2)
        s Bx = $p($p($P(line2,"Button B:",2),",",1),"+",2)
        s Ay = $p($p($P(line1,"Button A:",2),",",2),"+",2)
        s By = $p($p($P(line2,"Button B:",2),",",2),"+",2)

        s Px = $p($p($P(line3,"Prize:",2),",",1),"=",2)
        s Py = $p($p($P(line3,"Prize:",2),",",2),"=",2)

        s sum = sum + ..SolveSystemEq(Ax,Bx,Px, Ay,By,Py)

    }
   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod SolveSystemEq(X1, X2, Px, Y1, Y2, Py) As %Integer
{
    s sum = 0
    s B = (((Py - ((Y1*Px)/X1)) * ((X1)/ ((Y2*X1) - (X2*Y1)))) + 0.1)\1
    s A = (((Px - (X2*B))/X1)+ 0.1)\1
 
    if ..VerifyEq(A,X1,B,X2,Px) && ..VerifyEq(A,Y1,B,Y2,Py) {
        return ((A*3) + B)
    }
    return sum
}

ClassMethod VerifyEq(A, Ax, B, Bx, Pz) As %Integer
{
    s ans = (A*Ax) + (B*Bx) 
    return ans=Pz
}

}
