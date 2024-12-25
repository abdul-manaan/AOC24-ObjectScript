# Advent of Code 2024

## Language: ObjectScript

## How to Execute?
 For each day, we can compile and execute the code using following commands:
```IRIS
do $system.OBJ.CompileAll()

do ##class(aoc24.Day1).Run() // This will run both parts
do ##class(aoc24.Day1).Part1()
do ##class(aoc24.Day1).Part2()
```
To Run all the parts for all days, you can do this using:
```
# The Format is RunAll(fileNamePrefix)
do ##class(aoc24.Day1).RunAll("AoC2024_test/set2/day")
```
Note: 
1. Replace Day1 by any day from 1-25
2. The default input file: "/irisdev/app/data/24-dayX.txt"
3. You can also pass input filename, as argument to `Run(filename)` or `Part1(filename)` or `Part2(filename)`. The file must be present in "/irisdev/app/data/"

The answer will look as follows:
```
SUM is: 2399
Time: 13.361986276
```
Note: SUM (Solution Unveiling Moment) is the answer for that part and Time is the execution time in seconds.

## Execution Times for Advent of Code 2024

| Day  | Part 1 Time (s)   | Part 2 Time (s)   |
|------|-------------------|-------------------|
| Day 1  | 0.002553207 | 0.002438376   |
| Day 2  | 0.005373103 | 0.009184702   |
| Day 3  | 0.001202485 | 0.002643826   |
| Day 4  | 0.01547939  | 0.017016697   |
| Day 5  | 0.01111903  | 0.056296149   |
| Day 6  | 0.002524944 | 45.399245615  |
| Day 7  | 0.157863132 | 8.829965685   |
| Day 8  | 0.001176178 | 0.001223903   |
| Day 9  | 0.035663658 | 7.130279741   |
| Day 10 | 0.008703781 | 0.013339221   |
| Day 11 | 0.063987734 | 119.710597785 |
| Day 12 | 0.065009385 | 0.09725628    |
| Day 13 | 0.0070171   | 0.005046075   |
| Day 14 | 0.001452587 | 7.55455648    |
| Day 15 | 0.029908544 | 0.119301293   |
| Day 16 | 0.107641753 | 0.250494519   |
| Day 17 | 0.00051792  | 0.034431276   |
| Day 18 | 0.027187295 | 0.047618341   |
| Day 19 | 0.624253337 | 0.61705515    |
| Day 20 | 0.066070875 | 1.77851057    |
| Day 21 | 0.001791133 | 0.023660914   |
| Day 22 | 6.764094565 | 18.955308598  |
| Day 23 | 0.064578856 | 2.225752621   |
| Day 24 | 0.009010558 | 0.005571736   |
| Day 25 | 0.010005084 | 0.238924875   |


## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

1. Clone/git pull the repo into any local directory

```bash
git clone git@github.com:abdul-manaan/AOC24-ObjectScript.git
```

2. Open the terminal in this directory and run:

```bash
docker-compose build
```

3. Copy Input Files to ./data directory within this directory.

4. Run the IRIS container with your project:

```bash
docker-compose up -d
```

## How to Test it

Open IRIS terminal:

```bash
docker-compose exec iris iris session iris
```

Run the following commands:
```IRIS
USER>do $system.OBJ.Compile("aoc24.Day1")
USER>do ##class(aoc24.Day1).Part1()
```
