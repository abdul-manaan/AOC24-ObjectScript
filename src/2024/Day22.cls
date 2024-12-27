Class aoc24.Day22 Extends aoc24.Base
{

Parameter InputFile = "24-day22.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)

    set sum = 0
    s idx = 0
    s dp = 0
    s maxBananas = 0

	while 'stream.AtEnd  {
		set line=stream.ReadLine()

        do ..getNthSecretWithDP(+line,2000,.dp,$I(idx),.maxBananas)
    }

    s sum = maxBananas
   
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
        s sum = sum + ..getNthSecret(+line,2000)
    }

    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod getNthSecret(number, n, ByRef dp)
{
   
    for i=1:1:n {
        s s1 = $zb(number,(number*64),6) # 16777216
        s s2 = $zb(s1,(s1\32),6) # 16777216
        s number = $zb(s2,(s2*2048),6) # 16777216
    }
    return number
}

ClassMethod getNthSecretWithDP(number, n, ByRef dp, idx, ByRef maxBananas)
{
    s seq = ",,,"
    s newUnit = number#10
    for i=1:1:n {
        s prevUnit = newUnit
        s s1 = $zb(number,(number*64),6) # 16777216
        s s2 = $zb(s1,(s1\32),6) # 16777216
        s number = $zb(s2,(s2*2048),6) # 16777216

        s newUnit = number#10

        s seq = seq _ "," _ (newUnit - prevUnit)

        
        s seq = $e(seq,$find(seq,","),*)
        if $GET(dp(seq,idx),-1) = -1 {
            do $I(dp(seq,idx))
            s maxBananas(seq) = $get(maxBananas(seq),0) + newUnit
            s:(maxBananas(seq) > maxBananas) maxBananas = maxBananas(seq)
        }
    }
    return number
}

}
