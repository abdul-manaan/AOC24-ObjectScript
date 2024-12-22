Class aoc24.Day1 Extends aoc24.Base
{

Parameter InputFile = "24-day1.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0
    set firstList = ""
    set secondList = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        if ($Get(firstList($PIECE(line," ",1)))) {
            do $I(firstList($PIECE(line," ",1)))
        } else {
            s firstList($PIECE(line," ",1)) = 1
        }
        if ($Get(secondList($PIECE(line,"   ",2)))) {
            do $I(secondList($PIECE(line,"   ",2)))
        } else {
            s secondList($PIECE(line,"   ",2)) = 1
        }
    }
    s num1 = ""
    s num2 = ""
    s count1 = 0
    s count2 = 0
    while 1 {
        set num1 = $order(firstList(num1),1,count1)
        quit:(num1 = "")
        s num2 = $Get(secondList(num1),0)
        if (num2) {
            s sum = sum + (secondList(num1)*count1*num1)
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
    set firstList = ""
    set secondList = ""
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        if ($Get(firstList($PIECE(line," ",1)))) {
            do $I(firstList($PIECE(line," ",1)))
        } else {
            s firstList($PIECE(line," ",1)) = 1
        }
        if ($Get(secondList($PIECE(line,"   ",2)))) {
            do $I(secondList($PIECE(line,"   ",2)))
        } else {
            s secondList($PIECE(line,"   ",2)) = 1
        }
    }
    s num1 = ""
    s num2 = ""
    s count1 = 0
    s count2 = 0
    while 1 {
        set curNum1 = $order(firstList(num1),1,count1)
        quit:(curNum1 = "")
        set curNum2 = $order(secondList(num2),1,count2)
        quit:(curNum2 = "")
        s sum = sum + $zabs(curNum1-curNum2)
        if (count1 = 1) {
            s num1 = curNum1
        } else {
           s firstList(curNum1) = count1 - 1
        }
        if (count2 = 1) {
            s num2 = curNum2
        } else {
           s secondList(curNum2) = count2 - 1
        }
    }
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

}
