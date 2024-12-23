Class aoc24.Base Extends %RegisteredObject
{

Parameter Folder = "/irisdev/app/data/";

ClassMethod GetInput(fn) As %Stream.FileCharacter
{
   
    set fn=..#Folder_fn
    set stream = ##Class(%Stream.FileCharacter).%New()
    do stream.LinkToFile(fn)
    
    return stream
}

ClassMethod ParseString(str As %String, Output ans) As %Status
{
    try{
        set index = 1
        for i=1:1:$LENGTH(str," ") {
            set token = $zstrip($PIECE(str," ",i),"<w")
            if token '= "" {
                set ans(index) = token
                set index = index + 1
            }
        }
    } Catch exp {
        return exp.AsStatus()
    }
    return $$$OK
}

ClassMethod Part1(filename)
{
}

ClassMethod Part2(filename)
{
}

ClassMethod Run(filename AS %String = "")
{
	set part1 = ..Part1(filename)
	set part2 = ..Part2(filename)

    write "Part-1: ", part1,!
    write "Part-2: ", part2,!
}

}
