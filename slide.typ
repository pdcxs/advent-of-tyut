#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "@preview/zebraw:0.6.1": *
#import "@preview/numbly:0.1.0": numbly
#show: zebraw.with(lang: false)

#set text(font: ("JetBrains Mono", "LXGW WenKai"))
#set math.mat(align: left)
#set par(justify: true)

#show: university-theme.with(
    config-info(
    title: "动态规划算法入门",
    subtitle: "程序设计竞赛集训营",
    date: datetime.today(),
    institution: "太原理工大学",
    ),
    aspect-ratio: "16-9")

#set heading(numbering: numbly("{1}.", default: "1.1"))
#title-slide()

== Outline <touying:hidden>

#text(size: 21pt)[
#components.adaptive-columns(outline(title: none, indent: 1em))
]

= 编程的本质？

== 人类的本质是复读机

#v(2em)

每一种强有力的语言，都为此（能够将简单的认识组合起来形成更复杂认识的方法）提供了三种机制:

- *基本表达形式*：用于表示语言所关心的最简单的个体。
- *组合的方法*：通过它们可以从较简单的东西出发构造出复合的元素。
- *抽象的方法*: 通过它们可以为复合对象命名，并将它们当作单元去操作。

#align(right)[——《计算机程序的构造和解释》]

#pagebreak()

#v(2em)

人类的大脑，是一个内存极小的电脑，不擅长记忆大量的临时变量。

#pause

我们更加擅长思考如何将复杂问题，拆解成更小的子问题。

#pause

两个典型的例子：

$
  n! = lr(\{
       mat(
    1\,, n=0;
    n dot (n-1)!\,, n > 0;
    delim: #none
))
$

$
    F(n) = lr(\{
         mat(
        n\,, n<=1;
        F(n-1) + F(n-2)\,, n > 1;
        delim: #none
    ))
$

#pagebreak()

#v(2em)

它们有一个共同点：都是通过将复杂问题分解为更小的子问题来解决的。

#pause

假如我们已经知道了如何把一个复杂问题变成更加简单的问题，

#pause

而最简单的问题我们又已经知道答案了。

#pause

那就意味着，所有的问题我们都能解决了！

（*数学归纳法的思路*）

== 程序中的递归

那么我们该如何在程序中实现这种“分解问题”的思路呢？

#pause

答案是：*递归*。

#pause

以上代码几乎可以直接翻译成递归函数：

#zebraw(
highlight-lines: (
  (2, [一般而言，递归函数包含两个部分：基准情形和递推情形。]),
  (3, [注意，这里没有放入到 `else` 当中，因为前面相当于是一个守卫，不满足条件的情况已经返回了，这里就可以少一层缩进。])
),
```cpp
unsigned long long factorial(unsigned int n) {
  if (n == 0) return 1;
  return n * factorial(n - 1);
}
```
)

#pagebreak()

```cpp
unsigned long long factorial(unsigned int n) {
  if (n == 0) return 1;
  return n * factorial(n - 1);
}
```

为何函数在还没有完成定义的时候就可以调用自己呢？

答案是：因为函数定义的时候，函数体内的代码*并不会立刻执行*。

当函数被调用时，会创建一个新的执行环境，这个环境中包含了函数的参数和局部变量。

#pagebreak()

这个函数的定义，相当于是把系列的指令打包起来，放在一个盒子里，并将其关联到一个名字上。

当我们调用这个函数时，会先传入参数的值，然后执行打包好的指令。

当执行到自身的调用时，会更新传入的参数，并在全局环境中查找函数的定义，然后在新的执行环境中执行函数体内的代码。

== 递归的展开

让我们来看看递归函数在运行时的具体过程：

$
  n! = lr(\{
       mat(
    1\,, n=0;
    n dot (n-1)!\,, n > 0;
    delim: #none
))
$

$5! pause \
= 5 times 4! pause = 5 times (4 times 3!) pause = 5 times (4 times (3 times 2!)) pause = 5 times (4 times (3 times (2 times 1!))) pause \
= 5 times (4 times (3 times (2 times 1))) \
pause  = 5 times (4 times (3 times 2)) pause \
= 5 times (4 times 6) pause \
= 5 times 24 pause \
= 120
$

#pagebreak()

我们再来看一下斐波那契数列的递归展开：

$
  F(4) pause &= F(3) + F(2) pause \
  &= (F(2) + F(1)) + F(2) pause \
    &= ((F(1) + F(0)) + F(1)) + F(2) pause \
    &= ((1 + 0) + 1) + F(2) pause \
    &= 2 + F(2) pause \
    &= 2 + (F(1) + F(0)) pause \
    &= 2 + (1 + 0) pause = 3
$

#pagebreak()

可以看到，这个展开是二维的。可以通过计算得到，$F(n)$总共需要计算$2F(n-1)+1$次。也就是大概是$O(2^n)$的时间复杂度。

#pause

我们可以实验一下这个计算方法在`C++`语言中的计算速度：

```cpp
unsigned long long fibonacci(unsigned int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}
```

当$n = 50$时，已经基本无法在合理时间内计算出结果了。

== 尾递归优化

可以看到，我们需要不断地得到临时的计算结果，也就是所谓的*中间状态*，有时也被称为*栈帧*。对于阶乘而言，是一个一维的展开。

#pause

这种写法实际上是非常低效的，因为它会重复计算很多中间结果。那么有什么办法可以避免这种重复计算呢？

#pause

一种简单有效的的方法是，我们把中间结果手动保存到参数里面。

#pagebreak()

```cpp
unsigned long long factorial_helper(
    unsigned int n,
    unsigned long long accumulator) {
  if (n == 0) return accumulator;
  return factorial_helper(n - 1, n * accumulator);
}

unsigned long long factorial(unsigned int n) {
  return factorial_helper(n, 1);
}
```

#pagebreak()

或者，利用参数默认值简化写法：

```cpp
unsigned long long factorial(
    unsigned int n,
    unsigned long long accumulator = 1) {
  if (n == 0) return accumulator;
  return factorial(n - 1, n * accumulator);
}
```

#pagebreak()

现在，函数的展开方式为：

$
  5! pause &= f(5, 1) pause \
  &= f(4, 5 times 1 = 5) pause \
  &= f(3, 4 times 5 = 20) pause \
  &= f(2, 3 times 20 = 60) pause \
  &= f(1, 2 times 60 = 120) pause \
  &= f(0, 120) pause = 120
$

#pagebreak()

需要注意的是，这一特性需要编程语言是严格求值的顺序：即先对参数的值进行计算，然后再调用函数。不过幸运的是，大多数主流编程语言都是如此的。

#pause

我们再来看看斐波那契数列的尾递归写法：

```cpp
unsigned long long fibonacci(
    unsigned int n,
    unsigned long long a = 0,
    unsigned long long b = 1) {
  if (n == 0) return a;
  return fibonacci(n - 1, b, a + b);
}
```

#pagebreak()

当我们函数最终只是*一个*自身的重复，我们要要做的只是更新参数的值时，编译器就可以进行*尾递归优化*，将递归调用转换为循环，从而避免了大量的中间状态保存。

#pause

这是因为，尾递归实际上非常好优化，我们可以手动来实现以上递归函数的循环版本：

#pagebreak()

#v(2em)

```cpp
unsigned long long factorial(unsigned int n) {
  unsigned long long accumulator = 1;
  while (n > 0) {
    // Update two parameters
    accumulator *= n;
    n--;
  }
  return accumulator;
}
```

#pagebreak()

#v(1em)

```cpp
unsigned long long fibonacci(unsigned int n) {
  unsigned long long a = 0;
  unsigned long long b = 1;
  while (n > 0) {
    // Update three parameters
    unsigned long long temp = a;
    a = b;
    b = temp + b;
    n--;
  }
  return a;
}
```

#pagebreak()

所以，*任何循环，都可以被重写为尾递归函数*。

递归函数的优势在于：

- 直观展示了问题的分解过程，更加符合人类的思维习惯。
- 可以写出无变量的代码，减少心智负担。
- 如果优化为尾递归，可以被编译器优化为循环，并无性能损失。
- 基于数学归纳法的思路，可以在很大程度上保证代码的正确性。

#pause

不过也存在一些小问题：

- 中间状态过多时，需要维护大量的参数，代码可读性下降。
- 并非所有语言都支持尾递归优化，可能存在栈溢出风险。
- 不太方便调试。


== 案例：幂次算法

一个数的$n$次幂，可以定义为：

$
  x^n = lr(\{
       mat(
    1\,, n=0;
    x dot x^(n-1)\,, n > 0;
    delim: #none
))
$

可以写为（挑战一下看看能否尾递归优化）：

```cpp
using Result = long long;
using Input = int;

Result power(Input x, Input n) {
  return n == 0 ? 1 : x * power(x, n - 1);
}
```

#pagebreak()

但是，我们还可以用以下思路进行优化:

如果$n$是偶数，那么$x^n = x^(n/2) dot x^(n/2)$

如果$n$是奇数，那么$x^n = x dot x^((n-1)/2) dot x^((n-1)/2)$

#pagebreak()

可以写为：

```cpp
using Result = long long;
using Input = int;

Result quick_power(Input x, Input n) {
  if (n == 0) {
    return 1;
  }
  Result r = quick_power(x, n / 2);
  return n % 2 == 0 ? r * r : x * r * r;
}
```

#pagebreak()

那么我们应该如何进行尾递归优化？

#pause

首先重新认识这一过程：我们可以认为，$x^n$，变换成了$(x^2)^(n/2)$，再往后变换。

#pause

同时，还需要一个记录在变换过程中，有哪些值需要额外乘一下：

$x^n = x dot ((x^2)^((n-1)/2))$，此时多乘了一个$x$。

#pause

最后，会得到一个$x^1$的形式，再变换，得到$x dot (x^2)^0 = x dot 1 = x$。

于是，最终可以写成：

#pagebreak()

#v(2em)

#text(size: 20pt)[
```cpp
using Result = long long;
using Input = int;

Result better_quick_power(Input x, Input n, Input acc = 1) {
  if (n == 0)
    return acc;
  if (n == 1)
    return x * acc;
  if (n % 2 == 0)
    return better_quick_power(x * x, n / 2, acc);
  return better_quick_power(x * x, n / 2, acc * x);
}
```
]

= 记忆化递归

== 问题过于复杂？

#v(2em)

- 并不是所有的问题都能被简单地进行尾递归优化。

#pause

- 也就是说，虽然所有的循环都可以被写成递归形式，但是并非所有的递归都可以写成循环形式。

#pause

- 还有一点，有时把递归进行尾递归优化，往往会带来很大的心智负担。

== 记忆化方法

我们再来看一下斐波那契数列

如果我们觉得$F(n)$本质上是两个数字反复叠加这一规律难以发现，同时又觉得递归形式过于复杂，有什么办法能够既保留最简单的问题分解描述形式，又保证足够的性能呢？

我们可以采用一种策略：*结果记忆*，又被称为 *memoize*。

有很多按照函数式编程的方式实现的memoize的库#footnote[https://github.com/jimporter/memo]，不过，我们这里只采用手动的方式来实现最简单的记忆化策略。

#pagebreak()

#text(size: 14pt)[
```cpp
#include <iostream>
#include <unordered_map>

using Result = unsigned long long;
using Input = unsigned int;
using Record = std::unordered_map<Input, Result>;

Result memo_fib(Input n, Record &rec) {
  if (n < 2) {
    return n;
  }
  if (rec.find(n) != rec.end()) {
    return rec[n];
  }
  Result r = memo_fib(n - 1, rec) + memo_fib(n - 2, rec);
  rec[n] = r;
  return r;
}

int main() {
  Record rec;
  std::cout << memo_fib(50, rec);
}
```
]

= 动态规划

== 什么是动态规划？

其实，我们之前的思路，已经把动态规划的全部内容说完了：

#pause

- 明确如何将复杂问题分解为更加简单的问题
#pause
- 明确最简单问题的解
#pause
- 记忆中忆计算的结果

#pause
这就是全部了。不过大家看到真正的竞赛类解法时，很少用`unordered_map`或者`map`来记忆结果，而是采用在栈上分配数组来实现记忆化。这样做的好处是性能高，坏处是代码可读性差，心智负担略高。本课程面向想要了解竞赛的同学，因此采用更加简单的`map`来实现记忆化。

== 典型的动态规划问题

=== 硬币找零问题

#text(size: 24pt)[
以下问题选自欧拉计划第31题#footnote[https://projecteuler.net/problem=31]，是一个非常经典的动态规划问题。

英国的货币单位分为英镑（$pound$）和便士（$p$）。目前流通的硬币一共有八种面值：

$
1p, 2p, 5p, 10p, 20p, 50p, pound 1(100p), pound 2(200p)
$

想要凑出$pound 2$，其中一种做法是：

$
1 times pound 1 + 1 times 50 p + 2 times 20p + 1 times 5p + 1 times 2 p  + 3 times 1p
$

不限制硬币数量，凑出$pound 2$有多少种不同的做法？
]

#pagebreak()

我们的思路是：

对于要凑的钱$n$，以及现有的硬币：$bold(x) = {x_1, x_2,dots,x_c}$，其中，$c$ 是硬币的数量，我们有以下分解思路：

#pause

分两种情况，

1. 我们先尝试花一下$x_c$，那么问题变为了$n - x_c$和$bold(x)$
2. 我们不使用$x_c$，那么问题变成了$n$和$bold(x) \\ {x_c}$
3. 如果现在的目标变成了$0$，说明找零成功了，返回$1$
4. 如果目标变成了负数，或者目标大于零的前提下，没有硬币了，则找零失败，返回$0$

#pagebreak()

#columns(2)[
#text(size: 13pt)[
```cpp
#include <iostream>
#include <map>
#include <tuple>
#include <vector>

using Money = int; // 需要负数，所有不是unsigned int
using Coins = std::vector<Money>;
using CoinsNum = size_t;
using Input = std::tuple<Money, CoinsNum>;
using Result = unsigned long long;
// tuple 作为 unordered_map 的 key 需要实现 hash
// 与本课程无关，因此直接采用 map，性能会略有损失
using Record = std::map<Input, Result>;

Result solve(Money target,
             const Coins &coins,
             CoinsNum n,
             Record &rec) {
  if (target == 0)
    return 1;
  if (target < 0 || n <= 0)
    return 0;

  Input input = std::make_tuple(target, n);
  if (rec.find(input) != rec.end()) {
    return rec[input];
  }

  Money current = coins[n - 1];
  Result r =
      solve(target - current, coins, n, rec) +
      solve(target, coins, n - 1, rec);
  rec[input] = r;
  return r;
}

int main() {
  Coins coins = {1, 2, 5, 10, 20, 50, 100, 200};
  Record rec;
  std::cout << solve(200, coins, coins.size(), rec);
}
```
]]

#pagebreak()

=== 硬币问题变体

有一种硬币找零问题的变体：给定硬币种类和目标钱数，问凑齐目标钱数最少需要多少个硬币？$-1$表示无法凑出目标钱数。

这个问题作为挑战大家自行完成。

#pagebreak()

=== 最大公共子序列问题

此问题选自 LeetCode 1143：

给定两个字符串 `text1` 和 `text2`，返回这两个字符串的最长*公共子序列*的长度。如果不存在公共子序列，返回 $0$。

一个字符串的*子序列*是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。

例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是 "abcde" 的子序列。

两个字符串的*公共子序列*是这两个字符串所共同拥有的子序列。

#pagebreak()

问题分解：

对于字符串$s_1$和$s_2$：

1. $f(i, j)$表示$s_1$的前$i$个字符和$s_2$的前$j$个字符的最长公共子序列
2. 如果$s_1 [i] = s_2 [j]$，则$f(i,j) = f(i - 1, j - 1) + 1$
3. 否则，$f(i,j) = max{f(i - 1, j), f(i, j - 1)}$
4. $i$或者$j$为$0$时，$f(i,j) = 0$

#pagebreak()

#columns(2)[
#text(size: 14pt)[
```cpp
#include <iostream>
#include <map>
#include <string>
#include <tuple>

using Index = int;
using Input = std::tuple<Index, Index>;
using Output = Index;
using Record = std::map<Input, Output>;

Output lcm_helper(const std::string &s1,
                  const std::string &s2,
                  Index i, Index j,
                  Record &rcd) {
  if (i < 0 || j < 0)
    return 0;
  Input input = std::make_tuple(i, j);
  if (rcd.find(input) != rcd.end())
    return rcd[input];

  if (s1[i] == s2[j]) {
    Output r =
      lcm_helper(s1, s2, i - 1, j - 1, rcd) + 1;
    rcd[input] = r;
    return r;
  }

  Output r = std::max(
    lcm_helper(s1, s2, i - 1, j, rcd),
    lcm_helper(s1, s2, i, j - 1, rcd));
  rcd[input] = r;
  return r;
}

Output lcm(const std::string &s1,
           const std::string &s2) {
  Record rcd;
  return lcm_helper(
    s1,
    s2,
    s1.size() - 1,
    s2.size() - 1,
    rcd);
}
```
]]

#pagebreak()

如果用数组的话，实际上效率会高很多：

#text(size: 14pt)[
```cpp
using std::string;
using std::vector;

size_t better_lcm(const string &s1, const string &s2) {
  size_t n1 = s1.size();
  size_t n2 = s2.size();

  vector<vector<size_t>> rec(n1 + 1, vector<size_t>(n2 + 1, 0));

  for (size_t i = 1; i <= n1; i++) {
    for (size_t j = 1; j <= n2; j++) {
      if (s1[i - 1] == s2[j - 1]) {
        rec[i][j] = rec[i - 1][j - 1] + 1;
      } else {
        rec[i][j] = std::max(rec[i][j - 1], rec[i - 1][j]);
      }
    }
  }
  return rec[n1][n2];
}
```
]

#pagebreak()

#slide(composer: (1fr, 1fr))[

=== 路径数问题

此问题选自 Advent of Code 2025 Day 11#footnote[https://adventofcode.com/2025/day/11].

已知输入是一个单向图，每一行表示某个结点的后续连接节点列表。

问：从 `svr` 节点出发，经过 `fft` 结点与 `dac` 节点后，到达 `out` 的路线，总共有多少种？
][
#text(size: 14pt)[
```
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
```
]
]

#pagebreak()

从节点$i$到节点$j$的所有路线，相当于是节点$i$所有后续节点到结点$j$的路线的和。因为每个节点可能是多个节点的后续节点，因此需要记忆，避免重复计算。

#pagebreak()

#columns(2)[
#text(size: 10pt)[
```cpp
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

using Node = string;
using Graph = unordered_map<Node, vector<Node>>;
using Count = unsigned long long;
using Record = unordered_map<Node, Count>;

void parse_line(const string &line, Graph &graph) {
  istringstream in(line);
  Node n1;
  in >> n1;
  n1 = n1.substr(0, 3);
  vector<Node> outs;
  Node tmp;
  while (in >> tmp) {
    outs.push_back(tmp);
  }
  graph[n1] = outs;
}

Count count_helper(const Graph &graph, const Node &from,
                   const Node &to, Record &rec) {
  if (from == to)
    return 1;
  if (rec.find(from) != rec.end())
    return rec[from];
  if (graph.find(from) == graph.end())
    return 0;
  auto nexts = graph.at(from);
  Count sum = 0;
  for (const auto &n : nexts) {
    sum += count_helper(graph, n, to, rec);
  }
  rec[from] = sum;
  return sum;
}

Count count(const Graph &graph, const Node &from, const Node &to) {
  Record rec;
  return count_helper(graph, from, to, rec);
}

int main(int argc, char **argv) {
  ifstream file(argv[1]);
  Graph graph;
  string line;
  while (getline(file, line)) {
    parse_line(line, graph);
  }
  Count svr_fft = count(graph, "svr", "fft");
  Count fft_dac = count(graph, "fft", "dac");
  Count dac_out = count(graph, "dac", "out");
  Count svr_dac = count(graph, "svr", "dac");
  Count dac_fft = count(graph, "dac", "fft");
  Count fft_out = count(graph, "fft", "out");
  cout << svr_fft * fft_dac * dac_out +
          svr_dac * dac_fft * fft_out
       << "\n";
}
```
]]

#pagebreak()

=== 魔法石

#text(size: 18pt)[
此题选自 Advent of Code 2025 Day 11#footnote[https://adventofcode.com/2024/day/11].

有一系列刻有数字的魔法石，当我们观察它们时，无事发生。只要没有观察它们（眨一下眼睛），它们就会发生变化，变化规律如下：

- 数字$0$会变为数字$1$
- 如果数字的长度是偶数，则左右分成两个数字，并去除数字的前置0。比如，$1001$会被分为$10$和$1$
- 如果以上条件都不成立，则数字乘以2024
- 无论如何变化，数字的顺序是为变的

问：眨了$75$次眼睛后，总共有多少块石头？
]

#pagebreak()

问题的转换已经写明了，有不同的记忆方式。不过，与之前不一样的是，我们这次不再记忆参数的值，而是记忆对应数字的石头有多少块。

#pagebreak()

#columns(2)[
#text(size: 12pt)[
```cpp
#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

using Stone = unsigned long long;
using Count = unsigned long long;
using Record = std::unordered_map<Stone, Count>;
using Stones = std::vector<Stone>;

Stones transform(Stone s) {
  if (s == 0) return {1};

  std::string str = std::to_string(s);
  if (str.size() % 2 == 0) {
    auto half = str.size() / 2;
    auto s1 = str.substr(0, half);
    auto s2 = str.substr(half);
    return {(Stone)std::atoll(s1.c_str()),
            (Stone)std::atoll(s2.c_str())};
  }

  return {s * 2024};
}

Record blink(const Record &rec) {
  Record new_stones;
  for (auto &pair : rec) {
    auto stone = pair.first;
    auto count = pair.second;
    auto generated = transform(stone);
    for (auto ns : generated) new_stones[ns] += count;
  }
  return new_stones;
}

Count count(const Record &rec) {
  Count s = 0;
  for (auto &pair : rec) s += pair.second;
  return s;
}

int main(int argc, char **argv) {
  std::fstream file(argv[1]);
  Record rec;
  std::string s;
  while (file >> s)
    rec[(Stone)std::atoll(s.c_str())] += 1;
  for (int i = 0; i < 75; i++) rec = blink(rec);
  std::cout << count(rec) << "\n";
}
```
]]

= 总结

#pagebreak()

- 其本质上是一种结果记忆+数学归纳法
#pause
- 通过问题分解，将复杂问题分解为更加简单的问题
#pause
- 通过结果记忆，避免重复计算
#pause
- 如果可以采用数组进行记忆，效率会更高
#pause
- 不一定是记忆函数的参数，根据实际情况灵活变动
#pause
- 简单方法是采用`unordered_map`或者是`map`
#pause
- `C++`中，复杂的数据类型往往不能保存到`unordered_map`中，除非手动实现`hash`函数。在一般的其他编程语言中没有这一问题（如`Python`中的`dict`，`Rust`中的`HashMap`等等）
#pause
- `C++`由于历史包袱太重，导致语言比较难用。建议有兴趣的同学可以尝试一下其他现代语言。


= 扩展：现代语言

#pagebreak()

- 现代语言实际上在语言表达能力、内在安全性上，都比`C++`好用不少。
- 我们以`Rust`语言为例，看一下前面的两个问题如何表达。
- 最后我们会看看惰性求值的方式下的记忆策略（选择性学习，扩展内容，以`Haskell`语言为例）。

== 回看硬币找零

#columns(2, gutter: 10pt)[
#text(size: 17pt)[
```rust
use std::collections::HashMap;

type Money = i32;
type Coins = [Money];
type Count = u64;
type Record<'a> =
  HashMap<(&'a Coins, Money), Count>;

fn main() {
  let coins =
    [1, 2, 5, 10, 20, 50, 100, 200];
  let target: Money = 200;
  let mut memo: Record = HashMap::new();
  let result =
    solve(&coins, target, &mut memo);
  println!("{}", result);
}

fn solve<'a>(
  coins: &'a Coins,
  target: Money,
  memo: &mut Record<'a>) -> u64 {
  if let Some(&cached) = 
         memo.get(&(coins, target)) {
      return cached;
  }

  let result = match (coins, target) {
    (_, 0) => 1,
    ([], _) => 0,
    (_, t) if t < 0 => 0,
    ([first, rest @ ..], t) =>
      solve(coins, t - first, memo) + 
      solve(rest, t, memo),
  };
  memo.insert((coins, target), result);
  result
}
```
]]

== 魔法石问题偏函数式解法

#columns(2, gutter: 5pt)[
#text(size: 13pt)[
```rust
use std::collections::HashMap;

type Stone = u64;
type Count = u64;
type Record = HashMap<Stone, Count>;

fn transform(s: Stone) -> Vec<Stone> {
    if s == 0 {
        return vec![1];
    }
    let digits = 
      (s as f64).log10().floor() as u32 + 1;
    if digits.is_multiple_of(2) {
        let divisor = 10u64.pow(digits / 2);
        vec![s / divisor, s % divisor]
    } else {
        vec![s * 2024]
    }
}

fn blink(rec: Record) -> Record {
    let mut next_gen = Record::new();
    for (stone, count) in rec {
        for next_stone in transform(stone) {
            *next_gen.entry(next_stone)
                     .or_insert(0) += count;
        }
    }
    next_gen
}

fn main() {
    let input = std::env::args()
        .nth(1)
        .expect("Please provide an input file path");
    let stones_text =
        std::fs::read_to_string(input).unwrap();
    let record = stones_text
        .split_whitespace()
        .filter_map(|s| s.parse::<Stone>().ok())
        .fold(Record::new(), |mut acc, stone| {
            *acc.entry(stone).or_insert(0) += 1;
            acc
        });
    let record = (0..75).fold(
      record, |rec, _| blink(rec));
    println!("{}",
      record.values().sum::<Count>());
}
```
]
]

== 惰性求值硬币问题（选）

此处是可选内容

还记得函数的描述么？把指令打包起来，暂不执行。

实际上，利用这一特性，我们可以构建一个称为`Thunk`的结构，它的内容包含了求值的指令，和求值的结果。在不需要它的值的时候，不求值。在第一次需要它的值的时候，执行指令并把计算到的结果保存好。之后，再需要它的值的时候，直接返回之前的计算结果。

听起来很美好，但是把程序的所有表达式变成`Thunk`，有一个严苛到极致的需求：不允许变量的存在。我们必需确保每次求值的结果都是一样的。

`Haskell`语言把惰性求值作为语言的默认行为。

在没有变量的前提下，如何实现记忆化？

一种典型的方法是利用惰性列表结构：

```haskell
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

main :: IO ()
main = print $ fibs !! 50 -- 打印第 50 个斐波那契数列
```

我们再来看看硬币找零问题：

#pagebreak()

```haskell
type Money = Int
type Coin = Money
type Count = Integer
solve :: Money -> [Coin] -> Count
solve target coins =
 foldl' step initSolution coins !! target
 where
  initSolution = 1 : repeat 0
  step s coin =
   let s' = take coin s ++ zipWith (+) (drop coin s) s'
   in s'
main :: IO ()
main = print $ solve 200 [1, 2, 5, 10, 20, 50, 100, 200]
```
