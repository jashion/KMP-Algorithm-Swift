//: Playground - noun: a place where people can play

import UIKit

extension String {
    //BM，字符串匹配算法 => O(n)
    //Sunday，字符串匹配算法 => O(n)
    
    //KMP，字符串匹配算法 => O(n+m)
    func matchSubStr(_ subStr: String) -> (Bool, Int) {
        var match: Bool = false
        var matchIndex: Int = -1
        guard !subStr.isEmpty else {
            print("\(match), \(matchIndex)")
            return (match, matchIndex)
        }
        
        let next: [Int] = self.nextTable(subStr)
        
        var i = 0  //文本串
        var j = 0  //模式串
        let length = self.count
        let matchLenghth = subStr.count
        
        while i < length && j < matchLenghth {
            if j == -1 || self.subStrAtIndex(i) == subStr.subStrAtIndex(j) {
                i = i + 1
                j = j + 1
            } else {
                j = next[j]
            }
        }
        
        if j == matchLenghth {
            match = true
            matchIndex = i - j
            return (true, i - j)
        } else {
            match = false
            matchIndex = -1
            return (false, -1)
        }
    }
    
    func subStrAtIndex(_ index: Int) -> Character {
        let startIndex = self.startIndex
        let endIndex = self.endIndex
        let length = self.count
        if index <= 0 {
            let exceptionIndex = self.index(startIndex, offsetBy: 1)
            return Character(String(self[startIndex..<exceptionIndex]))
        } else if index >= length {
            let exceptionIndex = self.index(startIndex, offsetBy: length - 1)
            return Character(String(self[exceptionIndex..<endIndex]))
        }
        let subStartIndex = self.index(startIndex, offsetBy: index)
        let subEndIndex = self.index(startIndex, offsetBy: index+1)
        return Character(String(self[subStartIndex..<subEndIndex]))
    }
    
    //KMP计算next数组
    func nextTable(_ matchStr: String) -> [Int] {
        guard matchStr.count > 0 else {
            return []
        }
        
        let length = matchStr.count
        var next: [Int] = [-1]
        var k = -1
        var j = 0
        while j < length - 1 {
            //p[k]表示前缀,p[j]表示后缀
            if k == -1 || matchStr.subStrAtIndex(j) == matchStr.subStrAtIndex(k) {
                k = k + 1
                j = j + 1
                //优化
                if matchStr.subStrAtIndex(j) != matchStr.subStrAtIndex(k) {
                    next.insert(k, at: j)
                } else {
                    //因为不能出现p[j] = p[ next[j]]，所以当出现时需要继续递归，k = next[k] = next[next[k]]
                    next.insert(next[k], at: j)
                }
            } else {
                k = next[k]
            }
        }
        return next
    }
}

let match = "ABCDABD"
print(match.matchSubStr("BH"))
