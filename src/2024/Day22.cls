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

ClassMethod getNthSecret(number, n)
{
    s orig = number
    for i=1:1:n {
        set number = ..applyStep3(..applyStep2(..applyStep1(number)))
    }
    return number
}

ClassMethod applyStep1(secret)
{
    s number = secret*64
    s number = $ZBOOLEAN(secret,number,6)
    s number = number # 16777216
    return number
}

ClassMethod applyStep2(secret)
{
    s number = secret\32
    s number = $ZBOOLEAN(secret,number,6)
    s number = number # 16777216
    return number
}

ClassMethod applyStep3(secret)
{
    s number = secret*2048
    s number = $ZBOOLEAN(secret,number,6)
    s number = number # 16777216
    return number
}

ClassMethod getNthSecretWithDP(number, n, ByRef dp, idx, ByRef maxBananas)
{
    s orig = number
    s seq = ",,,"
    s newUnit = number#10
    for i=1:1:n {
        s prevUnit = newUnit
        set number = ..applyStep3(..applyStep2(..applyStep1(number)))

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
