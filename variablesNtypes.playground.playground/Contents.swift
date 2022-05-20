//import UIKit
//
//var greeting = "Hello, playground"
//
//// this is a single line comment (CMD + '/')
//
///*
// This is a multiline comment
// */
//
//
///*
// the 'let' keyword defines a constant
// the ': String' after the variable name denotes the datatype\   a variable with out a specific data type can hold any unless it sis a constant
// */
//let myStr: String = "this is a string"
//
//print(myStr)
//
//let myInt: Int = 10
//
//let myDouble: Double = 3.14
//
//// this is a variable
//var str = "any text"
//
//for i in str{
//    print(i)
//}
//
//let name = "Luthfor"
//var age = 23
//let pro = "He, Him, His"
//let skill = "idk"
//
//print("Hi, I'm \(name). I am \(age) and my pronouns are \(pro). \(skill) what im good at.")
//
//func greet(person: String) {
//    print("Hello \(person)")
//}
//
//greet(person: name)
//
//

class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        var charSet: Set<Character> = []
        let car = Array(s)
        var left = 0
        var right = 0
        var res = 0
        
        // Atempt using Swift String
        // for r in s {
        //     while charSet.contains(r) {
        //         charSet.remove(s[s.index(s.startIndex, offsetBy: left)])
        //         left = left + 1
        //     }
        //     right = right + 1
        //     charSet.insert(r)
        //     res = max(res, (right - left))
        // }
        
        // Atempt using char array
        for r in car {
            while charSet.contains(r) {
                charSet.remove(car[left])
                left = left + 1
            }
            right = right + 1
            charSet.insert(r)
            res = max(res, (right - left))
        }
        
        return res
    }
}
