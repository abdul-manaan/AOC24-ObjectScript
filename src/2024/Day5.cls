Class aoc24.Day5 Extends aoc24.Base
{

Parameter InputFile = "24-day5.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0
    s rules = ""
    s updates = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        if $LENGTH(line,"|") = 2 {
            s num1 = $PIECE(line,"|",1)
            s num2 = $PIECE(line,"|",2)

            s ruleNum = $I(rules(num1))
            s rules(num1,ruleNum) = num2
        } elseif ($LENGTH(line, ",") > 1) {
            s updateNum = $I(updates)
            s updates(updateNum) = $l(line,",")
            for i=1:1:$l(line,",") {
                s updates(updateNum,$PIECE(line,",",i)) = i
            }
        }
    }
    for i=1:1:updates {
        s isOrdered = ..DoesUpdateFollowOrder(i, .rules, .updates)
        if 'isOrdered {
            do GetCorrectOrder(i, .rules, .updates)
            s middle = ..GetMiddle2(i,.updates)
            s sum = sum + middle
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
    s rules = ""
    s updates = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        if $LENGTH(line,"|") = 2 {
            s num1 = $PIECE(line,"|",1)
            s num2 = $PIECE(line,"|",2)

            s ruleNum = $I(rules(num1))
            s rules(num1,ruleNum) = num2
        } elseif ($LENGTH(line, ",") > 1) {
            s updateNum = $I(updates)
            s updates(updateNum) = $l(line,",")
            for i=1:1:$l(line,",") {
                s updates(updateNum,$PIECE(line,",",i)) = i
            }
        }
    }
    for i=1:1:updates {
        s isOrdered = ..DoesUpdateFollowOrder(i, .rules, .updates)
        if isOrdered {
            s middle = ..GetMiddle(i,.updates)
            s sum = sum + middle
        } 
    }
    
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod DoesUpdateFollowOrder(UpdNum, ByRef Rules, ByRef Updates) As %Integer
{
    s currPage = ""
    for {
        s currPage = $ORDER(Updates(UpdNum, currPage))
        q:(currPage="")
        s currPos = Updates(UpdNum,currPage)

        for ri=1:1:$GET(Rules(currPage),0) {
            s nextFollower = Rules(currPage, ri)
            s nextFollowerPos = $GET(Updates(UpdNum, nextFollower),0)
            if nextFollowerPos {
                if nextFollowerPos < currPos {
                    return 0
                }
            }
        }
    }
    return 1
}

ClassMethod GetCorrectOrder(UpdNum, ByRef Rules, ByRef Updates) As %Integer
{
    s currPage = ""
    for {
        s currPage = $ORDER(Updates(UpdNum, currPage))
        q:(currPage="")
        s currPos = Updates(UpdNum,currPage)

        for ri=1:1:$GET(Rules(currPage),0) {
            s nextFollower = Rules(currPage, ri)
            s nextFollowerPos = $GET(Updates(UpdNum, nextFollower),0)
            if nextFollowerPos {
                if nextFollowerPos < currPos {
                    s Updates(UpdNum,nextFollower) = currPos+(1/(1+$RANDOM(8000)))
                    return ..GetCorrectOrder(UpdNum,.Rules,.Updates)
                }
            }
        }
    }
    return 1
}

ClassMethod GetMiddle(UpdNum, ByRef Updates) As %Integer
{
    s mid = Updates(UpdNum) \2 + 1
    s currPage = ""
    for {
        s currPage = $ORDER(Updates(UpdNum, currPage))
        q:(currPage="")
        s currPos = Updates(UpdNum,currPage)

        if currPos=mid {
            return currPage
        }
    }
    return -1
}

ClassMethod GetMiddle2(UpdNum, ByRef Updates) As %Integer
{
    s newUps = ""
    s currPage = ""
    for {
        s currPage = $ORDER(Updates(UpdNum, currPage))
        q:(currPage="")
        s currPos = Updates(UpdNum,currPage)
        s newUps(currPos, currPage) = 1
    }

    s mid = (Updates(UpdNum) \2) + 1

    s currPage = ""
    s count = 0
    for {
        s currPage = $ORDER(newUps(currPage))
        q:(currPage="")
        s count = count + 1
         
        if count=mid {
            return $ORDER(newUps(currPage,""))
        }
    }
    return -1
}

}
