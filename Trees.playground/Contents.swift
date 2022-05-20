import Foundation

// created node class
class Node {
    var val: Int
    var lChild: Node?
    var rChild: Node?
    
    init(){
        self.val = 0
        self.lChild = nil
        self.rChild = nil
    }
    
    init (val: Int, lNode: Node?, rNode:Node?){
        // set node value
        self.val = val
        
        // set left child node if one was given
        if let left = lNode {
            self.lChild = left
        }
        
        // set right child node if one was given
        if let right = rNode {
            self.rChild = right
        }
    }
}

// get some default values in (bottom up)
var nodeList: [Node] = []
var valList: Set<Int> = []
var temp: Int = Int.random(in: 0...20)
var i = 0

// manually adding data (treeM - Manual tree creation)
var six = Node(val: 6, lNode: nil, rNode: nil)
var four = Node(val: 4, lNode: six, rNode: nil)
var five = Node(val: 5, lNode: nil, rNode: nil)
var two = Node(val: 2, lNode: four, rNode: five)
var three = Node(val: 3, lNode: nil, rNode: nil)
var one = Node(val: 1, lNode: two, rNode: three)
var treeM = one

func bfs(tree: Node) {
    var queue: [Node] = [tree]
    
    while !queue.isEmpty {
        // copy an item into queue
        let temp = queue[0]
        
        // remove first in queue
        queue.remove(at: 0)
        
        print(temp.val)
        
        if let l = temp.lChild {
            queue.append(l)
        }
        
        if let r = temp.rChild {
            queue.append(r)
        }
    }
}

func getHeight(_ tree: Node?) -> Int {
    if let node = tree {
        return (1 + max(getHeight(node.rChild), getHeight(node.lChild)))
    }

    return -1
}

func printTree(tree: Node) {
    let row = getHeight(tree)
    let col = Int(pow(Double(2), Double(row)))

    var output = Array(repeating: Array(repeating: "", count: col+1), count: row+1)

    func fill(root: Node?, h: Int, l: Int, ri:Int) {
        if let r = root {
            let mid = (l+ri)/2 //Int((Double(l)+Double(ri))/2)
            output[h][mid] = "\(r.val)"

            if let left = r.lChild {
                fill(root: left, h: h+1, l: l, ri: mid-1)
            }
            if let right = r.rChild {
                fill(root: right, h: h+1, l: mid+1, ri: ri)
            }
        }
    }

    fill(root: tree, h: 0, l: 0, ri: col)

    print(output)
}

printTree(tree: treeM)

func dfsPRE(tree: Node){
    print(tree.val)
    
    if let lval = tree.lChild {
        dfsPRE(tree: lval)
    }
    if let rval = tree.rChild {
        dfsPRE(tree: rval)
    }
}

func dfsIn(tree: Node){
    if let lval = tree.lChild {
        dfsIn(tree: lval)
    }
    
    print(tree.val)
    
    if let rval = tree.rChild {
        dfsIn(tree: rval)
    }
}

func dfsPOST(tree: Node){
    if let lval = tree.lChild {
        dfsPOST(tree: lval)
    }
    if let rval = tree.rChild {
        dfsPOST(tree: rval)
    }
    print(tree.val)
}
//// depth first search
//dfsPRE(tree: treeM)
//dfsIn(tree: treeM)
//dfsPOST(tree: treeM)
//bfs(tree: treeM)

//print(getHeight(treeM))

//for i in (0...10).reversed() {
//    print(i)
//}
//
func generateMatrix(_ n: Int) -> [[Int]] {
    var output: [[Int]] = Array(repeating: Array(repeating: 0, count: n), count: n)
    
    var top = 0
    var bottom = n - 1
    var left = 0
    var right = n - 1
    var num = 1
    
    while(left <= right && top <= bottom) {
        for col in stride(from: left, through: right, by: 1) {
            output[top][col] = num
            num += 1
        }
        top += 1
        
        for row in stride(from: top, through: bottom, by: 1) {
            output[row][right] = num
            num += 1
        }
        right -= 1
        
        for col in stride(from: right, through: left, by: -1) {
            output[bottom][col] = num
            num += 1
        }
        bottom -= 1
        
        for row in stride(from: bottom, through: top, by: -1) {
            output[row][left] = num
            num += 1
        }
        left += 1
    }
    
    
    return output
}

var test = generateMatrix(3)

func isValid(_ s: String) -> Bool {
    var str = Array(s)
    let open: Set<Character> = ["{", "[","("]
    var stack: [Character] = []
    
    var out = false
    
    if !open.contains(str[0]) || s.isEmpty {
        return false
    }
    
    for i in str {
        if open.contains(i) {
            stack.append(i)
        } else if i == "}" && !stack.isEmpty && stack[stack.count-1] == "{" {
            stack.remove(at: stack.count-1)
        } else if i == "]" && !stack.isEmpty && stack[stack.count-1] == "[" {
            stack.remove(at: stack.count-1)
        } else if i == ")" && !stack.isEmpty && stack[stack.count-1] == "(" {
            stack.remove(at: stack.count-1)
        } else {
            return false
        }
    }
    
    return stack.count == 0
    
}

//var test2 = isValid("(){{}}{}")

//
//// generate nodes
//while i < 5 {
//    while valList.contains(temp) {
//        temp = Int.random(in: 0...20)
//    }
//
//    valList.insert(temp)
//
//    nodeList.append(Node(val: temp, lNode: nil, rNode: nil))
//    i += 1
//}
//
//// Bild tree
//var tree: Node = nodeList[0]
//
//func traverseList(tree: inout Node, newNode: Node){
//    if newNode.val > tree.val {
//        if var _ = tree.rChild {
//            traverseList(tree: &tree, newNode: newNode)
//        } else {
//            tree.rChild = newNode
//        }
//    } else {
//        if var _ = tree.lChild {
//            traverseList(tree: &tree, newNode: newNode)
//        } else {
//            tree.lChild = newNode
//        }
//    }
//}
//
//for i in 1..<nodeList.count {
//    traverseList(tree: &tree, newNode: nodeList[i])
//}

//func bfs(tree: Node){
//    print(tree.val)
//
//    if let lval = tree.lChild {
//        bfs(tree: lval)
//    }
//    if let rval = tree.rChild {
//        bfs(tree: rval)
//    }
//
//    return
//}


func longestSubarray(_ nums: [Int], _ limit: Int) -> Int {
    if nums.count < 2 { return 1 }
    
    var subArray = [Int]()
    var val = 0
    
    for i in 0..<nums.count{
        for j in i..<nums.count{
            let diff = abs(nums[i...j].max()! - nums[i...j].min()!)
            
            if diff >= val && diff <= limit {
                if subArray.count < Array(nums[i...j]).count {
                    subArray = Array(nums[i...j])
                    val = diff
                    print(subArray)
                }
            }
        }
    }
    
    return subArray.count
}

var nums = [24,12,71,33,5,87,10,11,3,58,2,97,97,36,32,35,15,80,24,45,38,9,22,21,33,68,22,85,35,83,92,38,59,90,42,64,61,15,4,40,50,44,54,25,34,14,33,94,66,27,78,56,3,29,3,51,19,5,93,21,58,91,65,87,55,70,29,81,89,67,58,29,68,84,4,51,87,74,42,85,81,55,8,95,39]
var lim = 87

print(longestSubarray(nums, lim))

var tet = [21, 58, 91, 65, 87, 55, 70, 29, 81, 89, 67, 58, 29, 68, 84, 4, 51, 87, 74, 42, 85, 81, 55, 8]
print(tet.count)


var itm = [1,2,3,4]

print(itm[0...1])

itm.append(contentsOf: [])

print(itm)


func dfsInO(_ tree: Node) -> [Node] {
        var output: [Node] = []
        
        if let left = tree.lChild {
            output.append(contentsOf: dfsInO(left))
        }
        
        output.append(tree)
        
        if let right = tree.rChild {
            output.append(contentsOf: dfsInO(right))
        }
        
        return output
    }

func increasingBST(_ root: Node?) -> Node? {
        var list = [Node]()
        var i = 0
        var j = 1
        guard let tree = root else {return nil}
        
        list = dfsInO(tree)
    
        while j < list.count {
            list[i].lChild = nil
            list[i].rChild = list[j]
            
            i += 1
            j += 1
        }
    list[j-1].lChild = nil
    
    
        return list[0]
        
    }

// manually adding data (treeM - Manual tree creation)
var z0 = Node(val: 1, lNode: nil, rNode: nil)
var z2 = Node(val: 3, lNode: nil, rNode: nil)
var z3 = Node(val: 4, lNode: z2, rNode: nil)
var z4 = Node(val: 2, lNode: z0, rNode: z3)

var treeM1 = z4

var out = increasingBST(treeM1)



var s = "slvafhpfjpbqbpcuwxuexavyrtymfydcnvvbvdoitsvumbsvoayefsnusoqmlvatmfzgwlhxtkhdnlmqmyjztlytoxontggyytcezredlrrimcbkyzkrdeshpyyuolsasyyvxfjyjzqksyxtlenaujqcogpqmrbwqbiaweacvkcdxyecairvvhngzdaujypapbhctaoxnjmwhqdzsvpyixyrozyaldmcyizilrmmmvnjbyhlwvpqhnnbausoyoglvogmkrkzppvexiovlxtmustooahwviluumftwnzfbxxrvijjyfybvfnwpjjgdudnyjwoxavlyiarjydlkywmgjqeelrohrqjeflmdyzkqnbqnpaewjdfmdyoazlznzthiuorocncwjrocfpzvkcmxdopisxtatzcpquxyxrdptgxlhlrnwgvee"
print(s.count)
print(s.count*s.count*s.count)

//func longestPalindrome(_ s: String) -> String {
//        var str = Array(s)
//
//        // if str.count <= 2 && isPal(str) {
//        //     return s
//        // } else {
//        //     return String(str[0])
//        // }
//
//        var longest = [Character]()
//        var arr = [Character]()
//        var len = 0
//
//        for i in 0..<str.count {
//            for j in i..<str.count {
//                arr = Array(str[i...j])
//
//                if isPal(arr) && (arr.count > len) {
//                    longest = arr
//                    len = arr.count
//                }
//            }
//        }
//
//        return String(longest)
//    }
//
//    func isPal(_ arr: [Character]) -> Bool {
//        var l = 0
//        var r = arr.count - 1
//
//        while l < r {
//            if arr[l] != arr[r] {
//                return false
//            }
//
//            l += 1
//            r -= 1
//        }
//
//        return true
//    }


//print(longestPalindrome(s))

var toup = (name: "test", val: 5)

toup.name

var tlist = [(name: String, val: Int)]()

tlist.append((name:"vale", val:5))

var vald = [Int:Int]()

vald[0] = 1
vald[1] = 1
vald[2] = 1
vald[3] = 1

print(vald)

if vald[4] != nil {
    print("here \(vald[4] ?? -1)")
} else {
    vald[4] = 1
    print("Added to dict")
}

if vald[4] != nil {
    print("here \(vald[4] ?? -1)")
} else {
    vald[4] = 1
    print("Added to dict")
}


// Haunted House Problem

// inputs
var n = 6

var list = [(1,2), (1,4), (0,3), (0,1), (3,4), (0,2)]

// tracker
func getPeople(n: Int, list: [(Int,Int)]) -> Int {
    var tracker = [Int:Int]()
    var numP = 0
    var instant = 0
    
    for (min, max) in list {
        print("\(min), \(max)")
    }
    
    for i in list {
        for j in i.0...i.1 {
            if tracker[j] != nil {
                if let val = tracker[j] {
                    tracker[j] = val+1
                }
            } else {
                tracker[j] = 1
            }
        }
    }

    for (key, val) in tracker {
        if val <= n && val > instant && key >= val {
            numP = key
            instant = val
        }
    }

    return numP
}

print(getPeople(n: n, list: list))


var letters: [Character] = ["e", "o", "b", "a", "m", "g", "l"]
var dict = ["go", "bat", "me", "eat", "goal", "boy", "run"]

func findWords(letters: [Character], dict: [String]) -> [String] {
    var out = [String]()
    
    for i in dict {
        for j in Array(i) {
            if !letters.contains(j) {
                break
            }
            if j == Array(i)[Array(i).count - 1] {
                out.append(i)
            }
        }
    }
    
    return out
}
print(findWords(letters: letters, dict: dict))

for i in stride(from: letters.count-1, through: 0, by: -1) {
    print("\(i) -->  letter: \(letters[i])")
}


func productExceptSelf(_ nums: [Int]) -> [Int] {
    //if nums.count < 2 {return nums}
    
    var out = [Int]()
    
    out.append(1)
    
    for i in 1..<nums.count {
        out.append(out[i-1]*nums[i-1])
    }
    
    var rightProduct = 1
    for j in stride(from: nums.count-1, through: 0, by: -1) {
        out[j] *= rightProduct
        rightProduct *= nums[j]
    }
    
    return out
}

var mesg = "The South Lake Union Streetcar is a streetcar route in Seattle, Washington, United States. Traveling 1.3 miles (2.1 km), it connects downtown to the South Lake Union neighborhood on Westlake Avenue, Terry Avenue, and Valley Street. It was the first modern Seattle Streetcar line, beginning service on December 12, 2007, two years after a separate heritage streetcar ceased operations. It was conceived as part of the redevelopment of South Lake Union into a technology hub, with lobbying and financial support from Paul Allen."

print(Double(mesg.count)/160.0)

func splitMsg(_ msg: String) -> [String] {
    var out = [String]()
    let mesg = msg.split(separator: " ")
    let limit = 160 - 6 // 154 -> space for _(x/y)
    
    var count = 0
    var current = ""
    
    for word in mesg {
        if (current + " " + word).count > limit {
            count += 1
            out.append(String(current))
            current = String(word)
        } else {
            if current.isEmpty {
                current = String(word)
            } else {
                current = current + " " + word
            }
        }
    }
    if !current.isEmpty {
        count += 1
        out.append(String(current))
    }
    
    for i in 0..<out.count {
        out[i] += " (\(i+1)/\(count))"
    }
    
    return out
}

for i in splitMsg(mesg) {
    print(i)
}

print(Int.min)

func factorial(_ n: Int) -> Int {
    if n < 1 {
        return 1
    }
    return n * factorial(n-1)
}

func permutation(n: Int, r: Int) -> Int {
    let numerator = factorial(n)
    let denominator = factorial(n-r)
    
    return numerator/denominator
}

func combination(n: Int, r: Int) -> Int {
    let numerator = factorial(n)
    let denominator = factorial(r) * (factorial(n-r))
    
    return numerator/denominator
}

for i in 0...5 {
    print(factorial(i))
}


print(permutation(n: 7, r: 3))
print(combination(n: 7, r: 3))


func numIslands(_ grid: [[String]]) -> Int {
    let height = grid.count
    let width = grid[0].count
    
    
    var matrix = grid
    var count = 0
    
    func removeIsland(_ i: Int, _ j: Int){
        if i < 0 || i >= height || j < 0 || j >= width || matrix[i][j] != "1" {
            return
        }
        
        matrix[i][j] = "0"
        removeIsland(i-1,j) // up
        removeIsland(i+1,j) // down
        removeIsland(i,j-1) // left
        removeIsland(i,j+1) // right
    }
    
    for i in 0..<height {
        for j in 0..<width {
            if matrix[i][j] == "1" {
                removeIsland(i, j)
                count += 1
            }
        }
    }
    
    return count
}

let input: [[String]] = [["1","1","0","0","0"],["1","1","0","0","0"],["0","0","1","0","0"],["0","0","0","1","1"]]

print(numIslands(input))


print(numIslands(input.reversed()))

print(5 * (pow(10, 2)))

print(pow(2, 32))


print((7-0)/2)


func binarySearch(_ arr: [Int], _ target: Int, _ left: Int, _ right: Int) -> Int {
    if left > right {
        return -1
    }
    
    let mid = (left + right)/2
    
    if arr[mid] == target {
        return mid
    }
    
    if arr[mid] > target {
        return binarySearch(arr, target, left, mid-1)
    } else if arr[mid] < target {
        return binarySearch(arr, target, mid+1, right)
    }
    
    return -1
}

let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23].sorted()

print(binarySearch(numbers.sorted(), 43, 0, numbers.count - 1))


// reverseing a linked list

class List {
    var val: Int
    var next: List? = nil
    
    init(val: Int, next: List) {
        self.val = val
        self.next = next
    }
    init(val: Int) {
        self.val = val
    }
    init() {
        self.val = 0
    }
    
    func print() {
        Swift.print(self.val)
    }
}

var l4 = List(val: 4)
var l3 = List(val: 3, next: l4)
var l2 = List(val: 2, next: l3)
var l1 = List(val: 1, next: l2)

// reverse singly linked list
func reverseList(head: List) -> List {
    var current = head
    var previous: List? = nil
    var temp = current.next
    
    while true {
        current.print()
        // get next item in linked list
        temp = current.next
        
        // set current item's next to previous
        current.next = previous
        
        // set previous to the current item
        previous = current
        
        // break if temp has reached the end of the list
        if temp == nil {
            break
        }
        
        // unwrap and set current to next
        if let next = temp {
            current = next
        }
    }
    
    return current
}

reverseList(head: l1)

var ans = 0

for i in 1..<1000 {
    if i.isMultiple(of: 5) || i.isMultiple(of: 3) {
        ans += i
    }
}

print(ans)
