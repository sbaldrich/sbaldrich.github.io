---
layout: post
title: "(24/300): We're Losing Strength, Captain!"
modified:
categories: cp
excerpt:
tags: [300pch, math, binary-search, python, scala]
image:
  feature:
date: 2015-10-10T14:10:01-05:00
---

Finally, after a sequence of major things (that Murphy himself seems to have devised) that stopped me from continuing with the challenge , I'm back with some more problems. A very nice math problem, a cute scala implementation and some easy python problems this time.

### Worms
<a href="http://codeforces.com/problemset/problem/474/B" target="_blank">Source</a>

Create a *cumsum* array with the number of worms present on each group and do a binary search for each juicy worm. You can also use something like [bisect_left](http://codeforces.com/contest/474/submission/8858078).

{% highlight python %}
from itertools import accumulate

def bs(vals, x):
    lo, mid, hi = 0, 0, len(vals) - 1
    while( lo < hi ):
        mid = (lo + hi) // 2
        if(x == vals[mid]):
            return mid
        elif( x > vals[mid] ):
            lo = mid + 1
        else:
            hi = mid
    return lo

n = int(input())
worms = list(map(int, input().split()))
m = int(input())
juicy = list(map(int, input().split()))
sums = list(accumulate(worms))

ans = [str(bs(sums, worm) + 1) for worm in juicy]
print('\n'.join(ans))
{% endhighlight %}

### Keyboard
<a href="http://codeforces.com/problemset/problem/474/A" target="_blank">Source</a>

Look forward or behind depending on the given direction shift.

{% highlight python %}
kb = 'qwertyuiopasdfghjkl;zxcvbnm,./'
direction = input()
shift = -1 if direction == 'R' else 1
message = input()
ans = [ kb[kb.index(c) + shift] for c in message]
print(''.join(ans))
{% endhighlight %}

### Olesya and Rodion
<a href="http://codeforces.com/problemset/problem/584/A" target="_blank">Source</a>

Depending on whether *t == 10*, you can easily create a number that satisfies the given conditions. Watch out for the special case, *e.g., t == 10 && n == 1*.


{% highlight python %}
n,t = map(int, input().split())
if( n == 1 and t == 10 ):
    print(-1)
else:
    ans = '1' +  '0' * (n - 1) if t == 10 else str(t) * n
    print(ans)
{% endhighlight %}

### Robot's task
<a href="http://codeforces.com/problemset/problem/583/B" target="_blank">Source</a>

The optimal strategy is to go all the way to each side taking all the possible information before turning.

{% highlight python %}
n = int(input())
a = list(map(int, input().split()))
turn = -1
current = 0
while(current < n):
    turn += 1
    for i in range(n):
        if(a[i] >= 0 and a[i] <= current):
            a[i] = -1
            current += 1
    a.reverse()
print(turn)
{% endhighlight %}

### Asphalting Roads
<a href="http://codeforces.com/problemset/problem/583/A" target="_blank">Source</a>

Using a couple of dictionaries, find out if the roads have been looked at before. If **none** of them have been visited, asphalt both of them.

{% highlight python %}
n = int(input())
ans = []
doneH = set()
doneV = set()
for i in range(n**2):
    m, n = map(int, input().split())
    if(m not in doneH and n not in doneV):
        ans.append(i + 1)
        doneH.add(m)
        doneV.add(n)
print(' '.join(str(x) for x in ans))
{% endhighlight %}

### Developing Skills
<a href="http://codeforces.com/problemset/problem/581/C" target="_blank">Source</a>

Very nice problem. The first thing to notice is that improving a particular skill will be of no use unless we increase it to the next multiple of 10, this means that the ones whose modulo 10 is bigger, are the ones we should improve first (more ROI). Another thing to notice is that we can get the rating before using improvement units and then add the rating obtained from using them to improve skills.
So, we can solve the problem by sorting the skills on their *mod10* and using the improvement units to get them to the next multiple of 10. If there are more units available, use them all and see if the rating is under the top limit (10 * n)

{% highlight python %}
n, k = map(int, input().split())
a = list(map(int, input().split()))
left = [0] * 11
rating = 0
for i in a:
    left[10 - i % 10] += 1
    rating += i // 10
for (i,q) in enumerate(left[1:], start = 1):
    possible = min(q, k // i) # How many units can I get?
    rating += possible
    k -= possible * i
print(min(rating + k // 10, 10 * n))
{% endhighlight %}

### Luxurious Houses
<a href="http://codeforces.com/problemset/problem/581/B" target="_blank">Source</a>

The code speaks for itself.

{% highlight python %}
n = int(input())
height = list(map(int, input().split()))
maxHeight = [0] * n # position i holds the tallest building in positions [i+1,n)
m = 0
for i in range(n-1,0,-1):
    m = max(height[i], m)
    maxHeight[i-1] = m
ans = [max(m - h + 1, 0) for (h,m) in zip(height, maxHeight)]
print(' '.join([str(x) for x in ans]))
{% endhighlight %}

### Vasya the Hipster
<a href="http://codeforces.com/problemset/problem/581/A" target="_blank">Source</a>

The code speaks for itself.

{% highlight python %}
red, blue = map(int, input().split())
mixed = min(red, blue)
red -= mixed
blue -= mixed
single = max(red, blue) // 2
print(mixed, single)
{%endhighlight%}

### Amr and the Large Array
<a href="http://codeforces.com/problemset/problem/558/B" target="_blank">Source</a>

Any array with the maximum beauty that does not start and end with the same number can be reduced. For each *x*, save the initial position and the end position as well as its beauty and, among all the generated triplets (start, end, beauty) take the shortest one that has the same beauty as the original array (which clearly would be the max).

{% highlight scala %}
import scala.io.StdIn.readLine

object AmrAndTheLargeArray{
  case class Triplet( left : Int, right : Int, count : Int)
  def main(args : Array[String]) : Unit = {
      readLine()
      val a = readLine().split("\\s+").map( _.toInt )
      val map = scala.collection.mutable.HashMap[Int, Triplet]()
      (a.zipWithIndex).foreach({
        case (a,i) => map.get(a) match {
          case None => map(a) = Triplet(i,i,1)
          case Some(Triplet(l,r,k)) => map(a) = Triplet(l,i,k+1)
        }
      })

      val ans = map.valuesIterator.reduceLeft( (thiz, that) => {
         if(thiz.count != that.count)
          if(thiz.count >= that.count) thiz else that
        else if ((thiz.right - thiz.left) <= (that.right - that.left)) thiz else that
      })

      val l = ans.left + 1
      val r = ans.right + 1
      println(l + " " + r)   
  }
}
{% endhighlight %}

### Conclusion

I've found myself spending too much time testing my solutions (copy-paste test cases, using an online REPL instead of a dedicated environment) and writing these posts, so it's time to write some scripts. See you next time.
