# KMP-Algorithm-Swift
swift版的KMP算法。

![KMP-BG.jpg](http://upload-images.jianshu.io/upload_images/968977-430b2eed104c4d5a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>为什么要写KMP字符串匹配算法呢？因为近段时间在补数据结构和算法，然后重拾大学的《大话数据结构》，记录一下学习的进度。

### 什么是KMP算法？
KMP算法是一种字符串匹配算法，时间复杂度为 **O(n+m)（n是文本的长度，m是模式字符串的长度）**，相比于传统的字符串匹配算法的时间负复杂度 **O(n * m)** 来说，大大提高字符串的匹配速度。

举个例子：
文本字符串 -> ABCABCDDDEABCDABHJJEEIDAEAENN
模式字符串 -> ABCDABC

在匹配前需要计算最大前缀和最大后缀的公共元素长度以及next数组（后面有说明）：

|                     模式串                       | A | B | C | D | A | B | C |
| ------------------------------- |  :-:  |  :-:  |  :-:  | :-:  |  :-:  | :-:  | :-: |
|最大前缀和后缀的公共元素长度 | 0 | 0 | 0 | 0 | 1 | 2 | 3 |
|next数组                                         | -1 | 0 | 0 | 0 | 0 | 1 | 2 |

假设文本字符串的下标为：**i ∈ [0, pl-1]（pl为文本字符串的长度）**，模式字符串的下标为：**j ∈ [0, sl-1]（sl为模式字符串的长度）**，则：
```swift
文本字符串 -> ABCABCDDDEABCDABHJJEEIDAEAENN
模式字符串 -> ABCDABC
KMP匹配的规则：
加入失配字符串的文字下表为j，则模式字符串往右移的位数为当前失配字符串的下标（已匹配的字符串长度）减去当前失配字符串的next数组对应的数值，此时模式匹配的下标j=next[j]。

ABCABCDDDEABCDABHJJEEIDAEAENN
ABCDABC

失配字符为A|D，所以
i = 3
j = 3
next[j] = 0
往右移动的位数 = j - next[j] = 3 - 0 = 3
j = next[j] = 0

ABCABCDDDEABCDABHJJEEIDAEAENN
   ABCDABC
继续匹配，直到j=sl-1或者i=pl-1，匹配结束。如果j=sl-1，则匹配成功，模式字符串在文本字符串的位置为：index = i - j，否则，匹配失败。
```

### KMP算法的步骤
上面简单的介绍了一下KMP字符串匹配算法的使用，现在详情介绍一下KMP算法的具体步骤以及一些相关名词的意义。

>最大前缀和后缀的公共元素长度计算。

模式字符串：**ABCDABC**

| 模式字符串的子串 | 前缀 | 后缀 | 最大的公共字符串 | 最大的公共字符串的长度 |
| -----------  | ---- | ----- | ------------------ | ----- |
| A | 空 | 空 | 空 | 0 |
| AB | A | B | 空 | 0 |
| ABC | A, AB | BC, C | 空 | 0 |
| ABCD | A, AB, ABC | BCD, CD, D | 空 | 0 |
| ABCDA | A, AB, ABC, ABCD | BCDA, CDA, DA, A | A | 1 |
| ABCDAB | A, AB, ABC, ABCD, ABCDA | BCDAB, CDAB, DAB, AB, B | AB | 2 |
| ABCDABC | A, AB, ABC, ABCD, ABCDA, ABCDAB | BCDABC, CDABC, DABC, ABC, BC, C | ABC | 3 |

所以，模式字符串的前缀后缀最大的公共元素长度为：

|                     模式串                       | A | B | C | D | A | B | C |
| ------------------------------- |  :-:  |  :-:  |  :-:  | :-:  |  :-:  | :-:  | :-: |
|最大前缀和后缀的公共元素长度 | 0 | 0 | 0 | 0 | 1 | 2 | 3 |

>那么？最大前缀和后缀的公共元素长度有什么用呢？

举个例子：
假如模式字符串在 **j=6** 的地方失配，那么我们需不需要从 **j=0**，重新开始匹配呢？答案是否定的。因为最大的已匹配的字符串长度为 **6**，最大的前缀后缀的公共元素长度为 **2**，也就是说，前缀和后缀有最大的公共元素AB，那么，AB这个元素在后缀是匹配过的，不需要重新匹配，所以，只需要从没有匹配过的下表开始就可以，下标需要往左移动的位数为 **6-2=4**，也就是 **j=6-4=2**，从下标 **j=2** 即 **C** 开始匹配，不需要重新匹配，节省了时间，提高了匹配的效率。
<br>**可以得到一个模式字符串失配时往左需要移动位数的公式：**
**需要移动的位数（n） = 当前已匹配的字符串长度（j） - 当前失配字符串上一个字符串的最大前缀后缀的公共元素长度（next[j-1]）**。

>理论上有 **最大前缀和后缀的公共元素长度** 就可以计算模式字符串在匹配失败时需要往左移动的位数，那么，为什么还需要 **next** 数组？

在`什么是KMP算法`一节里，可以看出，**next数组** 和 **最大前缀和后缀的公共元素长度** 数值的关系，**next数组** 就是 **最大前缀和后缀的公共元素长度** 整体往后移一位，超出的去掉，不足的补-1。那么其实，前面得出来的公式就可以写成这样：
**n = j - next[j]**
到此，可以知道，**next数组** 就是为了简化公式而弄出来的。

>现在再重新匹配一次《什么是KMP算法？》里的例子

```
文本字符串 -> ABCABCDDDEABCDABHJJEEIDAEAENN
模式字符串 -> ABCDABC
pl(文本字符串的长度)
sl(模式字符串的长度)
i(文本字符串的下标)
j(模式字符串的下标)
n(需要移动的位数)
```

|                     模式串                       | A | B | C | D | A | B | C |
| ------------------------------- |  :-:  |  :-:  |  :-:  | :-:  |  :-:  | :-:  | :-: |
|最大前缀和后缀的公共元素长度 | 0 | 0 | 0 | 0 | 1 | 2 | 3 |
|next数组                                         | -1 | 0 | 0 | 0 | 0 | 1 | 2 |

**第一次匹配失败：**

![第一次匹配失败.png](http://upload-images.jianshu.io/upload_images/968977-7e938a94bd83f7b3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
i = 3
j = 3
n = j - next[j] = 3 - 0 = 3
j = next[j] = 0
所以，从文本字符串i=3，模式字符串j=0开始重新匹配。
```

**第二次匹配**
![第二次匹配.png](http://upload-images.jianshu.io/upload_images/968977-9e533b923fb68f7b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
i = 7
j = 4
n = j - next[j] = 4 - 0 = 4
j = next[j] = 0
所以，从文本字符串i=7，模式字符串j=0开始重新匹配。
```
直到最后i=pl-1时，j != sl-1，匹配失败。

>使用代码实现KMP算法

首先，需要计算模式字符串的next数组。
很显然，j = 0时，next[0] = -1；
那么？怎么从next[j]推导next[j+1]呢？

假如j = 5，我们知道next[j] = 1，s[next[j]] = B，也就是最大的公共元素是AB，假如s[next[j] + 1] = s[j + 1]， 那么可以得出，前缀和后缀最大的公共元素是ABC， 则next[j + 1] = 2。这里可以得出，当s[next[j] + 1] = s[j + 1]则，next[j + 1] = next[j] + 1。如果s[next[j] + 1] != s[j + 1]呢？那么，我们假定存在一个比ABC小的最大前缀后缀公共元素，需要不断递归，直到s[next[next[j]] + 1] = s[j + 1]。如果存在k，使得s[next[k] + 1] = s[j + 1]，则next[j + 1] = next[k] + 1；如果不存在，则next[j + 1] = 0。

代码如下：
```swift
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
                next.insert(k, at: j)
            } else {
                k = next[k]
            }
        }
        return next
    }
```
当k=-1表示j=0，此时next[j+1]=k+1=0
当s[j]=s[k]表示找到了，此时next[j+1]=next[k]+1

获得模式字符串的next数组，可以开始匹配了，代码如下：
```swift
    //KMP，字符串匹配算法 => O(n+m)
    func matchSubStr(_ subStr: String) -> (Bool, Int) {
        guard !subStr.isEmpty else {
            return (false, -1)
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
            return (true, i - j)
        } else {
            return (false, -1)
        }
    }
```
**KMP字符串匹配算法要点在于减少比不要的匹配次数，提高匹配效率。**

### BM算法和Sunday算法
KMP算法，已经在字符串匹配的效率上提升了一个级别，然而，没有最快的算法，只有更快的算法。BM算法的时间复杂度是 **O(n)** 级别的，而Sunday算法比BM算法效率更高。意不意外，惊不惊喜。大神的境界远不是我等凡人可以揣摩的，致敬。😂

### 最后
献上Swift写的[KMP-Algorithm-Swift-Demo](https://github.com/jashion/KMP-Algorithm-Swift)。

>参考文献：
[极客学院：KMP算法](http://wiki.jikexueyuan.com/project/kmp-algorithm/define.html)
[阮一峰：字符串匹配的KMP算法](http://www.ruanyifeng.com/blog/2013/05/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm.html)
[The Knuth-Morris-Pratt Algorithm in my own words](http://jakeboxer.com/blog/2009/12/13/the-knuth-morris-pratt-algorithm-in-my-own-words/)
