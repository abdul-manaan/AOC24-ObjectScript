Class aoc24.Day23 Extends aoc24.Base
{

Parameter InputFile = "24-day23.txt";

ClassMethod Part2(filename = "") As %Integer
{
    s startTime = $p($ZTIMESTAMP,",",2)
    if filename = "" {
        s filename = ..#InputFile
    }
    set stream=..GetInput(filename)
    set sum = 0

	s nodeMap = 0
    s uniqueNodes = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")
        s node1 = $p(line,"-",1)
        s node2 = $p(line,"-",2)
        s nodeMap(node1,node2) = $I(nodeMap)
        s nodeMap(node2,node1) = nodeMap
        s uniqueNodes(node1) = 1
        s uniqueNodes(node2) = 1
    }

    s node = ""
    for {
        s node = $o(uniqueNodes(node))
        q:(node="")
        merge newUniqueNodes = uniqueNodes
        KILL newUniqueNodes(node)
        do ..findNodeSpan(.nodeMap,.dfs,.newUniqueNodes,node)
    }
    
    s maxLen = 0
    s it = ""
    for {
        s it = $o(dfs(it))
        q:(it="")
        if $l(it,",") > maxLen {
            s maxLen = $l(it,",")
            s sum = it
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


    s nodeMap = 0
    s uniqueNodes = 0
	while 'stream.AtEnd {
		set line=stream.ReadLine()
        continue:(line="")
        s node1 = $p(line,"-",1)
        s node2 = $p(line,"-",2)
        s nodeMap(node1,node2) = $I(nodeMap)
        s nodeMap(node2,node1) = nodeMap
        s uniqueNodes(node1) = 1
        s uniqueNodes(node2) = 1
    }

    s node = ""
    s idx = 0
    for {
        s node = $o(uniqueNodes(node))
        q:(node="")
        do ..findAll3ConnectedNodes(.nodeMap,.dfs,node, $I(idx))
    }
    s it = ""
    for {
        s it = $o(dfs(it))
        q:(it="")
        if $FIND(it,",t") '= 0 {
            s sum = sum + 1
        } elseif $e(it,1,1) = "t" {
            s sum = sum + 1
        }
    }
   
    w "SUM is: "_sum,!
    w "Time: ", $p($ZTIMESTAMP,",",2)-startTime,!
    return sum
}

ClassMethod findAll3ConnectedNodes(ByRef nodeMap, ByRef dfs, node1, idx)
{
    s node2 = ""
    s graphLen = 0
    for {
        s node2 = $o(nodeMap(node1,node2)) //1 <-> 2
        q:(node2="")
        s node3 = ""
        for {
            s node3 = $o(nodeMap(node2,node3)) // 2 <-> 3
            q:(node3="")
            if ($GET(nodeMap(node3,node1),0)'=0) {// 3 <-> 1
                s d(node1) = idx
                s d(node2) = idx
                s d(node3) = idx
                s n1 = $o(d(""))
                s n2 = $o(d(n1))
                s n3 = $o(d(n2))
                s dfs(n1 _","_n2_","_n3) = idx
                s graphLen = graphLen + 1
                KILL d               
            }
        }
    }
    return graphLen
}

ClassMethod findNodeSpan(ByRef nodeMap, ByRef dfs, ByRef uniqueNodes, currentSet)
{
    s dfs(currentSet) = 1
    s nextNode = ..findNextConnectedNode(.nodeMap, .uniqueNodes, currentSet)
    return:(nextNode = "")
    KILL uniqueNodes(nextNode)
    s newSet = currentSet_","_nextNode
    do ..findNodeSpan(.nodeMap, .dfs,.uniqueNodes,newSet)
    do ..findNodeSpan(.nodeMap, .dfs,.uniqueNodes,currentSet)
}

ClassMethod findNextConnectedNode(ByRef nodeMap, ByRef uniqueNodes, currentSet)
{
    s nextNode = ""
    for {
        s nextNode = $o(uniqueNodes(nextNode))
        q:(nextNode = "")
        s isConnectedToSet = 0
        for i=1:1:$l(currentSet,",") {
            s cNode = $p(currentSet,",",i) 
            if '($get(nodeMap(cNode,nextNode),0) = 0) {
                s isConnectedToSet = isConnectedToSet + 1
            }
        }
        if isConnectedToSet = $l(currentSet,",") {
            return nextNode
        }
    }
    return ""
}

}
