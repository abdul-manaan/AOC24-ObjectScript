Class aoc24.Day14 Extends aoc24.Base
{

Parameter InputFile = "24-day14.txt";

ClassMethod Part2(filename = "", totalWidth = 101, totalHeight = 103) As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)

    set sum = 0
    s data = 0

	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s px= $p($p($p(line," ",1),"=",2),",",1)
        s py= $p($p($p(line," ",1),"=",2),",",2)
        s vx= $p($p($p(line," ",2),"=",2),",",1)
        s vy= $p($p($p(line," ",2),"=",2),",",2)

        s data($I(data)) = px_","_py_"|"_vx_","_vy
    }
    Merge CopyOfData = data

    s sum = ..solveUsingVariance(totalWidth,totalHeight,.data)
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    
    return sum
}

ClassMethod Part1(filename = "", totalWidth = 101, totalHeight = 103) As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        set filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0
    s map = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        s px= $p($p($p(line," ",1),"=",2),",",1)
        s py= $p($p($p(line," ",1),"=",2),",",2)
        s vx= $p($p($p(line," ",2),"=",2),",",1)
        s vy= $p($p($p(line," ",2),"=",2),",",2)

        s newX = (vx*100) + px
        s newY = (vy*100) + py
        s newX = newX#totalWidth
        s newY = newY#totalHeight
        if px=2,py=4 {
            w newX, "  ---  ",newY,!
        }
        do $I(map(newX_","_newY))
    }

    s sum = ..CalcQuads(.map,totalWidth,totalHeight)

   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod CalcQuads(ByRef map, wid, hgt) As %Integer
{
    s q1=0,q2=0,q3=0,q4=0
    s it = ""
    for {
        s it = $o(map(it))
        q:it=""
        s x = $p(it,",",1)
        s y = $p(it,",",2)

        s:((x < (wid\2)) && (y < (hgt\2))) q1 = q1 + map(it)
        s:((x > (wid\2)) && (y < (hgt\2))) q2 = q2 + map(it)
        s:((x < (wid\2)) && (y > (hgt\2))) q3 = q3 + map(it)
        s:((x > (wid\2)) && (y > (hgt\2))) q4 = q4 + map(it)


    }
    return q1*q2*q3*q4
}

ClassMethod solveUsingVariance(wid, hgt, ByRef data)
{
    s map = ""
    s minVar = 10000000000
    s ans = 0
    for k=1:1:10000 {
        KILL map
        do ..CaclNextSecondPos(.map,wid,hgt,.data)
        s var = ..CalculateVarianceOfCoordinates(.map)
        s var = $p(var," ",1) + $p(var," ",2)
        if var < minVar {
            s minVar = var
            s ans = k
        } elseif var=minVar {
            w "Interesting Seconds: ",k, " var= ",var,!
        }
    }
    return ans
}

ClassMethod CaclNextSecondPos(ByRef map, totalWidth, totalHeight, ByRef data)
{
    for i=1:1:data {
        s it = data(i)
        s px = $p($p(it,"|",1),",",1)
        s py = $p($p(it,"|",1),",",2)
        s vx = $p($p(it,"|",2),",",1)
        s vy = $p($p(it,"|",2),",",2)

        s px = vx + px
        s py = vy + py
        s px = px#totalWidth
        s py = py#totalHeight

        do $I(map(px_","_py))
        s data(i) = px_","_py_"|"_vx_","_vy
    }
}

ClassMethod CalculateVarianceOfCoordinates(ByRef GlobalGrid)
{
    Set sumI = 0, sumJ = 0
    Set count = 0
    Set sumSquaredDifferencesI = 0, sumSquaredDifferencesJ = 0
    
    Set it = ""
    For {
        Set it = $Order(GlobalGrid(it))
        Quit:it=""
        
        set i = $p(it,",",1)
        set j = $p(it,",",2)
        
        Set value = $Get(GlobalGrid(it))
            
        If value <= 0 Continue
            
        Set sumI = sumI + i
        Set sumJ = sumJ + j
        Set count = count + 1
    }
    
    Set meanI = sumI / count
    Set meanJ = sumJ / count
    
    Set it = ""
    For {
        Set it = $Order(GlobalGrid(it))
        Quit:it=""
        
        set i = $p(it,",",1)
        set j = $p(it,",",2)
        
        Set value = $Get(GlobalGrid(it))
        
        If value <= 0 Continue
        
        Set sumSquaredDifferencesI = sumSquaredDifferencesI + ((i - meanI) ** 2)
        Set sumSquaredDifferencesJ = sumSquaredDifferencesJ + ((j - meanJ) ** 2)
    }
    
    Set varianceI = sumSquaredDifferencesI / count
    Set varianceJ = sumSquaredDifferencesJ / count
    
    
    Quit varianceI_" "_varianceJ
}

}
