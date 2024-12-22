Class aoc24.Day19 Extends aoc24.Base
{

Parameter InputFile = "24-day19.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

	s patterns = 0
    s designs = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")
        if (patterns = 0) {
            for i=1:1:$l(line,", ") {
                s patterns($I(patterns)) = $p(line,", ",i)
            }
        } else {
            s designs($I(designs)) = line
        }
    }

    s dp = 0 // we can reuse dp. NO need to delete it!!!
    for i = 1:1:designs {
        s score = ..IsDesignPossible(designs(i), .patterns, .dp)
        s sum = sum + score
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

    s patterns = 0
    s designs = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")
        if (patterns = 0) {
            for i=1:1:$l(line,", ") {
                s patterns($I(patterns)) = $p(line,", ",i)
            }
        } else {
            s designs($I(designs)) = line
        }
    }

    for i = 1:1:designs {
        s score = ..IsDesignPossible(designs(i), .patterns)

        if score > 0 {
            s sum = sum + 1
        }
    }

    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod IsDesignPossible(design, ByRef patterns, ByRef dp)
{
    if ($Get(dp(design),-1) '= -1) {
        return dp(design)
    }
    s sum = 0
    if $l(design) < 1 {
        return 1
    }
    for i=1:1:patterns {
        continue:($l(design) < $l(patterns(i)))
        if $l(design) = $l(patterns(i)) {
            if (design = patterns(i)) {
                s sum = sum + 1
            }
        } else {
            s pieceOFDesign = $EXTRACT(design,0,$l(patterns(i)))
            if pieceOFDesign = patterns(i) {
                set isRestPossible = ..IsDesignPossible($EXTRACT(design,$l(patterns(i))+1,*), .patterns, .dp)
                s sum = sum + isRestPossible
            }
        }
    }
    s dp(design) = sum
    return sum
}

}
