---
layout: post
title: "(75/300): Warming up again"
modified:
categories: cp
excerpt: ""
tags: [python, ad-hoc, c++, scala, codejam, warmup]
image:
  feature:
date: 2017-10-21T15:30:44-05:00
---

I haven't been dedicating much (any) time to competitive programming lately, so I thought it was about time to practice
once again. This time all the problems are simple enough to not require a detailed explanation, so I simply imported them from my repo
to create this post. I expect to be more organized from now on.


### Between Two Sets
<a href="https://www.hackerrank.com/challenges/between-two-sets" target="\_blank">Source</a>

{% highlight python %}
input()  # ignore
a = list(map(int, input().split()))
b = list(map(int, input().split()))
m = max(b)
print(len([n for n in range(1, m + 1) if all(n % i == 0 for i in a) and all(i % n == 0 for i in b)]))
{% endhighlight %}

### Birthday Chocolate
<a href="https://www.hackerrank.com/challenges/the-birthday-bar" target="\_blank">Source</a>

{% highlight python %}
n = int(input())
a = list(map(int, input().split()))
d, m = map(int, input().split())
print(sum([sum(a[i:i+m]) == d for i in range(len(a) - m + 1)]))
{% endhighlight %}

### Breaking the Records
<a href="https://www.hackerrank.com/challenges/breaking-best-and-worst-records" target="\_blank">Source</a>

{% highlight python %}
from itertools import accumulate

input()  #ignore
score = list(map(int, input().split()))

best = len(set(s for s, b in zip(score, list(accumulate(score, max))) if s == b)) - 1
worst = len(set(s for s, w in zip(score, list(accumulate(score, min))) if s == w)) - 1

print(best, worst)
{% endhighlight %}

### Kangaroo
<a href="https://www.hackerrank.com/challenges/kangaroo" target="\_blank">Source</a>

{% highlight python %}
x1, v1, x2, v2 = list(map(int, input().split()))
if v1 == v2:
    print('YES' if x2 == x1 else 'NO')
else:
    t = (x2 - x1) / (v1 - v2)
    print('YES' if t >= 0 and t % 1 == 0 else 'NO')
{% endhighlight %}

### Birthday Cake Candles
<a href="https://www.hackerrank.com/challenges/birthday-cake-candles" target="\_blank">Source</a>

{% highlight python %}
from itertools import accumulate

input()  # ignore it.
a = list(map(int, input().split()))
m = max(a)
print(sum(i == m for i in a))

{% endhighlight %}

### Minimax Sum
<a href="https://www.hackerrank.com/challenges/mini-max-sum" target="\_blank">Source</a>

{% highlight python %}
a = sorted([int(i) for i in raw_input().split()])
print(sum(a[:-1]), sum(a[1:])
{% endhighlight %}

### Time Conversion
<a href="https://www.hackerrank.com/challenges/time-conversion" target="\_blank">Source</a>

{% highlight python %}
import time
parsed = time.strptime(input(), '%I:%M:%S%p')
print(time.strftime('%H:%M:%S', parsed))
{% endhighlight %}

### A Very Big Sum
<a href="https://www.hackerrank.com/challenges/a-very-big-sum" target="\_blank">Source</a>

{% highlight python %}
input()
print(sum(map(int, input().split())))
{% endhighlight %}

### Diagonal Difference
<a href="https://www.hackerrank.com/challenges/diagonal-difference" target="\_blank">Source</a>

{% highlight python %}
n = int(input())
left, right = 0, 0
for i in range(n):
    row = list(map(int, input().split()))
    left += row[i]
    right += row[-i -1]
diff = left - right
print((-1 if diff < 0 else 1) * diff){% endhighlight %}

### Plus Minus
<a href="https://www.hackerrank.com/challenges/plus-minus" target="\_blank">Source</a>

{% highlight python %}
n = int(input())
nums = list(map(int, input().split()))
pos = sum(x > 0  for x in nums)
neg = sum(x < 0  for x in nums)
nul = sum(x == 0 for x in nums)
print(pos / n, neg / n, nul / n, sep = '\n')
{% endhighlight %}

### Staircase
<a href="https://www.hackerrank.com/challenges/staircase" target="\_blank">Source</a>

{% highlight python %}
n = int(input())
for i in range(1, n + 1):
    print(("{:>" + str(n) + "s}").format("#" * i)){% endhighlight %}

### Revenge of the Pancakes
<a href="https://code.google.com/codejam/contest/6254486/dashboard#s=p1" target="\_blank">Source</a>

{% highlight python %}
T = int( raw_input() )

for t in range(T):
    cakes = list(raw_input())
    moves = 0
    while True:
        if '-' not in cakes:
            break
        l = cakes.index('-')
        if l > 0:
            cakes[:l] = '-'
            moves += 1
        if '-' not in cakes:
            break
        r = len(cakes) - 1 - cakes[::-1].index('-')
        cakes[:r+1] = ['-' if c == '+' else '+' for c in cakes[r::-1]]
        moves += 1
    print "Case #%d: %d" % (t + 1, moves)
{% endhighlight %}

### Counting Sheep
<a href="https://code.google.com/codejam/contest/6254486/dashboard#s=p0" target="\_blank">Source</a>

{% highlight python %}
T = int( raw_input() )

for t in range(T):
    n = int( raw_input() )
    ans = "INSOMNIA"
    if n:
        ans = n
        s = set(str(n))
        i = 2
        while len(s) < 10 :
            ans = i * n
            i += 1
            s |= set(str(ans))
    print "Case #%d: %s" % (t + 1, ans)
{% endhighlight %}

### Compare the Triplets
<a href="https://www.hackerrank.com/challenges/compare-the-triplets" target="\_blank">Source</a>

{% highlight c++ %}
#include<iostream>

using namespace std;

int a[6], alice, bob;

int main(){
  for(int i = 0; i < 6; i++) cin >> a[i];
  for(int i = 0; i < 3; i++) alice +=  a[i] > a[i+3], bob += a[i] < a[i+3];
  cout << alice << " " << bob << endl;
  return 0;
}

{% endhighlight %}

### Manasa and Stones.cpp
<a href="https://www.hackerrank.com/challenges/manasa-and-stones" target="\_blank">Source</a>

{% highlight c++ %}
#include<bits/stdc++.h>

using namespace std;

set<int> ans;

void f( int a, int b, int c, int x ){
  if( !a ){
    ans.insert( x );
    return;
  }
  f( a-1, b, c, x+b );
  f( a-1, b, c, x+c );
}

int main(){
  int t, n, a, b;
  cin >> t;
  while( t-- ){
    cin >> n >> a >> b;
    f( n-1, a, b, 0 );
    while( !ans.empty() ){
      cout << *ans.begin();
      ans.erase( ans.begin() );
      if( !ans.empty() )
        cout << " ";
    }
    cout << endl;
  }
  return 0;
}
{% endhighlight %}


### New Year and Hurry
<a href="http://codeforces.com/contest/750/problem/A" target="\_blank">Source</a>

{% highlight scala %}
/**
  * Codeforces Good Bye 2016 A - New Year Hurry.
  * Source: http://codeforces.com/problemset/problem/750/A
  *
  * The problem is trivial.
  */
object NewYearHurry extends App{
  val Array(n,k) = io.StdIn.readLine.split("\\s+").map(_.toInt)
  val ans = (1 to n).map(5 * _).scanLeft(0)(_ + _).drop(1).takeWhile(_ <= 240 - k).size
  println(ans)
}
{% endhighlight %}

### Bachgold Problem
<a href="http://codeforces.com/contest/749/problem/A" target="\_blank">Source</a>

{% highlight scala %}
/**
  * Codeforces Round 388 A - Bachgold Problem.
  * Source: http://codeforces.com/problemset/problem/749/A
  *
  * The problem is trivial.
  */
object BachgoldProblem extends App{
  val n = io.StdIn.readInt()
  println(n / 2)
  println(n match{
    case n if n <= 3 => n
    case n if n % 2 == 0 => "2" + " 2" * (n / 2 - 1)
    case _ => "2" + " 2" * (n / 2 - 2) + " 3"
  })
}
{% endhighlight %}

### Santa Claus and a Place in a Class
<a href="http://codeforces.com/contest/752/problem/A" target="\_blank">Source</a>

{% highlight scala %}
/**
  * Codeforces Round 389 A - Santa Claus and a Place in Class.
  * Source: http://codeforces.com/problemset/problem/748/A
  *
  * Some simple divisions.
  */
object SantaClausAndAPlaceInAClass extends App{
  val Array(n, m, k) = io.StdIn.readLine.split("\\s+").map(_.toInt)
  val lane = Math.ceil(k / (2.0 * m)).toInt
  val desk = Math.ceil((k - (lane - 1) * 2 * m) / 2.0).toInt
  println(s"""$lane $desk ${if(k % 2 == 0) "R" else "L"}""")
}

{% endhighlight %}

### Lesha and Array Splitting.scala
<a href="http://codeforces.com/contest/754/problem/A" target="\_blank">Source</a>

{% highlight scala %}
/**
  * Codeforces Round 390 A - Lesha and Array Splitting.
  * Source: http://codeforces.com/problemset/problem/754/A
  *
  * The only way it isn't possible to split the array as desired is if all entries are zero, so firstly we must check for
  * this condition and answer NO if it is true. If not, greedily find the answer.
  */
object LeshaAndArraySplitting extends App{
  io.StdIn.readLine()
  val A : Array[Int] = io.StdIn.readLine().split("\\s+").map(_.toInt)
  if(A.count(_ == 0) == A.length){
    println("NO")
  } else{
    if(A.sum != 0) println(
      s"""
         |YES
         |1
         |1 ${A.length}
       """.stripMargin)
    else {
      def f(split : Int) : Int = {
        A.splitAt(split) match {
          case (l, r) if l.sum != 0 && r.sum != 0 => split
          case _ => f(split - 1)
        }
      }
      val split = f(A.length)
      println(
        s"""YES
           |2
           |1 $split
           |${split + 1} ${A.length}
         """.stripMargin)
    }
  }
}

{% endhighlight %}

### Gotta Catch 'em all
<a href="http://codeforces.com/contest/757/problem/A" target="\_blank">Source</a>

{% highlight scala %}
/**
  * Codeforces Round 391 A - Gotta Catch 'em All.
  * Source: http://codeforces.com/problemset/problem/757/A
  *
  * We must find how many times we can form the word 'Bulbasaur' using the letters in the text. Since we know how many
  * of each letter (two 'a's, one 'b', one 'B') we need to form the word, find out how many times we can get the required
  * number for each letter and return the minimum of these.
  */
object GottaCatchEmAll extends App{
  val textCount = io.StdIn.readLine().groupBy(_.toChar).mapValues(_.length)
  val bulbasaur = "Bulbasaur".groupBy(_.toChar).mapValues(_.length)
  val ans = bulbasaur.collect{ case (k, v) => textCount.getOrElse(k, 0) / v }.min
  println(ans)
}
{% endhighlight %}

## Some Last Words

* Noticed that neat trick for checking whether a number is integer using the modulo operator? ( ͡° ͜ʖ ͡°)
