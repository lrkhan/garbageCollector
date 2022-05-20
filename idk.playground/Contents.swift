import UIKit
import Darwin

var greeting = "Hello, playground"


func sumOfMultiplesOf3or5(to: Int) -> Int {
    // naive approach
    var ans: Int = 0
    
    for i in 1..<to {
        if i.isMultiple(of: 5) || i.isMultiple(of: 3) {
            ans += i
            //print(i)
        }
    }
    
    return ans
    
    //    /// the formula is on: https://www.xarg.org/puzzle/project-euler/problem-1/
    //    let n = Double(to - 1)
    //    let r = 3 * (n/2 * (n + 1))
    //    let s = 5 * (n/2 * (n + 1))
    //
    //    // 15 is the lcm so we can subtract the duplicates
    //    let t = 15 * (n/2 * (n + 1))
    //
    //    // return 1/2 * (3 * (n/3 * (n/3 + 1)) + 5 * (n/5 * (n/5 + 1)) - 15 * (n/15 * (n/15 + 1)))
    //    return Int(r + s - t)
}

print(sumOfMultiplesOf3or5(to: 1000))


func fibonacci(to: Int) -> [Int] {
    var out = [Int]()
    
    if to < 1 {
        return out
    }
    
    out.append(0)
    
    var curr = 1
    var prev = 0
    var sum = 0
    
    while out[out.count-1] <= to {
        if out.count < 2 {
            out.append(1)
        } else {
            sum = out[prev] + out[curr]
            
            out.append(sum)
            
            curr += 1
            prev += 1
        }
    }
    
    return out
}

var ans1 = fibonacci(to: 4_000_000)

var st = "aabccbab"
var str = Array(st)

var emp: Character = " "

print(emp == " ")
var arr: [[Character]] = Array(repeating: [], count: 5)


func convert(_ s: String, _ numRows: Int) -> String {
    if s.count < 2 || numRows < 2 { return s }
    
    let str = Array(s)
    var arr: [[Character]] = Array(repeating: [], count: numRows)
    var row = 0
    var out: String = ""
    var i = 0
    while i < str.count {
        if row >= numRows {
            row -= 1
            while row != 0 && i < str.count {
                row -= 1
                arr[row].append(str[i])
                i += 1
            }
            row += 1
            
            continue
        }
        
        arr[row].append(str[i])
        i += 1
        row += 1
    }
    
    for row in arr {
        out += String(row)
    }
    
    return out
}

print(convert("ABCD", 3))

var vat: [String] = ["5", "4", "C"]

for i in vat {
    if let val = Int(i) {
        print(val)
    }
}

print(["a","b"] == ["a","b"])


enum Day: String {
    case weekday = "Weekday"
    case weekend = "Weekend"
    case mon = "Monday"
    case tue = "Tuesday"
    case wed = "Wednesday"
    case thu = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"
}

func getReady(day: Day) {
    print("")
    print("Morning routine for: \(day.rawValue)")
    
    let weekday: [String] = ["brush", "make bed", "coffee"]
    let weekend: [String] = ["brush", "make bed", "coffee", "nap"]
    
    switch day {
    case .sat:
        fallthrough
    case .sun:
        fallthrough
    case .weekend:
        for i in weekend {
            print(i)
        }
    case .mon:
        fallthrough
    case .tue:
        fallthrough
    case .wed:
        fallthrough
    case .thu:
        fallthrough
    case .fri:
        fallthrough
    case .weekday:
        for i in weekday {
            print(i)
        }
    }
    
}

getReady(day: .mon)

print("bcad" > "bacd")

let string = "123456a"
var ar = string.map {$0.wholeNumberValue}
print(ar)
var ari = [Int]()
for i in Array(string) {
    if let val = i.wholeNumberValue {
        ari.append(val)
    }
}

func powTen(_ i: Int) ->Int {
    var out = 1
    
    for _ in 0..<i {
        out *= 10
    }
    
    return out
}
print(ari)
//Int(ari)
var sum = 0
for i in 0..<ari.count {
    sum += (ari[i] * powTen(ari.count - 1 - i))
}

print(sum)

func exp(_ base: Int, _ to: Int) -> Int {
    sum = 1
    
    for _ in 0..<to {
        sum *= base
    }
    
    return sum
}

print(exp(-2,31))


func myAtoi(_ s: String) -> Int {
        var trim = Array(s.trimmingCharacters(in: .whitespaces))
        var arr = [Int]()
        var isNegative = false
        var sum = 0
        
        if trim[0] == "-" || trim[trim.count-1] == "-" {
            trim.remove(at: trim[0] == "-" ? 0 : trim.count-1)
            isNegative = true
        }
        
        if trim[0] == "+" || trim[trim.count-1] == "+" {
            trim.remove(at: trim[0] == "+" ? 0 : trim.count-1)
        }
        
        func powTen(_ to: Int) -> Int {
            var out = 1
            
            for _ in 0..<to {
                out *= 10
            }
            
            return out
        }
        
        func exp(_ base: Int, _ to: Int) -> Int {
            var out = 1
            
            for _ in 0..<to {
                out *= base
            }
            
            return out
        }
        
        for i in trim {
            if let val = i.wholeNumberValue {
                arr.append(val)
            }
        }
        print(arr)
        for i in 0..<arr.count{
            sum += ( arr[i] * powTen(arr.count - 1 - i))
            print(sum)
        }
        print(sum)
        if isNegative {
            sum *= -1
        }
        
        if sum < exp(-2,31) {
            return exp(-2,31)
        }
        print(sum > (exp(2,31) - 1))
        if sum > (exp(2,31) - 1) {
            return (exp(2,31) - 1)
        }
        
        return sum
    }

myAtoi("words and 987")


func solution(inputString: String) -> Bool {
    let str = Array(inputString)
    var l = 0
    var r = str.count - 1
    
    while l < r {
        if str[l] != str[r] {
            return false
        }
        l += 1
        r -= 1
    }
    
    return true
}

solution(inputString: "abac")

 var l = [["a","b"],["d","c"]]

for i in l {
    i.contains("b") ? print("true"):print("false")
}

var val = Set<String> ()
val.contains("b")


var test = [ 5, 1, 4, 2, 8 ]

func bubbleSort(_ arr: [Int]) -> [Int] {
    // O(n^2) time complexity
    // O(n) space
    var out = arr
    var wasSwapped = true
    
    while wasSwapped {
        wasSwapped = false
        for i in 1..<out.count {
            if out[i-1] > out[i] {
                let temp = out[i]
                out[i] = out[i-1]
                out[i-1] = temp
                wasSwapped = true
            }
        }
    }
    
    return out
}

func mergeSort(_ arr: [Int]) -> [Int] {
    //print("Input: \(arr)")
    
    if !(arr.count > 1) {
        return arr
    }
    
    var out = [Int]()
    
    var i = 0
    var j = 0
    //var k = 0
    
    let mid = arr.count/2
    
    let l = mergeSort(Array(arr[0..<mid]))
    //print("left: \(l)")
    let r = mergeSort(Array(arr[mid..<arr.count]))
    //print("right: \(r)")
    
    while i < l.count && j < r.count {
        if l[i] < r[j] {
            out.append(l[i])
            i += 1
        } else if l[i] > r[j] {
            out.append(r[j])
            j += 1
        } else {
            out.append(r[j])
            out.append(l[i])
            i += 1
            j += 1
        }
    }
    
    while i < l.count {
        out.append(l[i])
        i += 1
    }
    
    while j < r.count {
        out.append(r[j])
        j += 1
    }
    //print("Output: \(out)")
    return out
}

print(test.sorted())

print(bubbleSort(test))

//print("")
//print("")
//print("")

print(mergeSort(test))

var tet = Set([[-1,0,1],[-1,2,-1],[0,1,-1]].map{ $0.sorted()})
var te = [-1,2,-1]//Set<[[Int]]>()
if tet.contains(te.sorted()){
    print("found")
}

te = [-1,0,1,2,-1,-4]
te.sorted()
print(te)

func threeSum(_ nums: [Int]) -> [[Int]] {
    if nums.count < 3 { return [[Int]]() }
    
    let n = nums.sorted()
    //var setOp = Set<[Int]>()
    var out = [[Int]]()
    
    for i in 0..<n.count {
        if i > 0 && n[i-1] == n[i] {
            continue
        }
        
        var j = i + 1
        var k = n.count - 1
        
        while j < k {
            if n[i] + n[j] + n[k] == 0 {
                out.append([n[i], n[j], n[k]])
                j += 1
                
                while j < k && n[j] == n[j-1] {
                    j += 1
                }
            } else if n[i] + n[j] + n[k] < 0 {
                j += 1
            } else {
                k -= 1
            }
        }
    }
    
    return out
}

threeSum(te)

var graph = [String:[String:Double]]()

//graph["b"] = ["a" : 1.2]
//graph["b"] = ["c" : 0.2]

if (graph["b"] != nil) {
    graph["b"]!["c"] = 0.2
} else {
    graph["b"] = ["a" : 1.2]
}
if (graph["b"] != nil) {
    graph["b"]!["c"] = 0.2
} else {
    graph["b"] = ["a" : 1.2]
}

graph["b"]!["d"] = 0.6
graph["b"]!["a"] = nil
print(graph)

print(graph["b"]!["d"]!)

func calcEquation(_ equations: [[String]], _ values: [Double], _ queries: [[String]]) -> [Double] {
    var visited = Set<String>()
    
    var graph = [String:[String:Double]]()
    
    var out = [Double]()
    
    var j = 0
    
    func graphInsert(_ key1: String, _ key2: String, _ val: Double)  {
        if graph[key1] != nil {
            graph[key1]![key2] = val
        } else {
            graph[key1] = [key2 : val]
        }
    }
    
    func dfs(_ start: String, _ end: String) -> Double {
        if !graph.keys.contains(start) || !graph.keys.contains(end) {
            return (-1.0)
        }
        
        if graph[start]![end] != nil {
            return (graph[start]![end]!)
        }
        
        for (key, _) in graph[start]! {
            if !visited.contains(key) {
                visited.insert(key)
                
                let temp = dfs(key, end)
                
                if temp == -1 {
                    continue
                } else {
                    return graph[start]![key]! * temp
                }
            }
        }
        
        return Double(-1)
    }
    
    // add relations to graph
    for i in equations {
        graphInsert(i[0], i[1], values[j])
        graphInsert(i[1], i[0], 1.0/values[j])
        
        j += 1
    }
    
    for q in queries {
        visited.removeAll()
        out.append(dfs(q[0],q[1]))
    }
    
    return out
}

print(calcEquation([["a","b"],["b","c"]], [2.0,3.0], [["a","c"],["b","a"],["a","e"],["a","a"],["x","x"]]))

[6, 4, 8, 10, 9].sorted() + [2,6,4,8,10,9,15].sorted()

[2,6,4,8,10,9,15].sorted()
