---
layout: post
title: "(15/300): Your python-fu is still weak"
modified:
categories: cp
excerpt:
tags: []
image:
  feature:
date: 2015-09-28T21:48:06-05:00
---

Some easy problems, all in python this time.

### Lala Land and Apple Trees
[Source](http://codeforces.com/problemset/problem/558/A)

It's easy to see that we're only going to be able to get to *l* trees on each side were *l* is the minimum number of trees on both sides. If the lengths are different, we can get one more (if there are 4 trees on the left and 3 on the right, start by the left side to get all 4 trees)

{% highlight python %}
n = int(input())
low = []
high = []
for i in range(n):
    x, apples = map(int, input().split())
    if x < 0:
        low.append((x,apples))
    else:
        high.append((x, apples))
low.sort(reverse = True)
high.sort()

possible = min(len(low), len(high)) + (1 if len(low) != len(high) else 0)
ans = sum([x[1] for x in low[:possible]]) + sum([x[1] for x in high[:possible]])

print(ans)
{% endhighlight %}


### Currency System in Geraldion
[Source](http://codeforces.com/problemset/problem/560/A)

Is there a banknote with the number 1? then all sums are possible. There isn't? ok, 1 is the smallest sum.

{% highlight python %}
input()
a = list(map(int, input().split()))
print(-1 if min(a) == 1 else 1)
{% endhighlight%}


### Simple Game
[Source](http://codeforces.com/problemset/problem/570/B)

We only need to beat Misha by one. Choose the largest available segment and choose the number in front of him. Look out for the corner case.

{% highlight python %}
n,m = map(int, input().split())
print( 1 if n == 1 else m + 1 if n - m > m - 1 else m - 1 )
{% endhighlight %}


### Elections
[Source](http://codeforces.com/problemset/problem/570/A)
Just do what the statement says.

{% highlight python %}
n, c = map(int, input().split())
score = [0] * n
for _ in range(c):
    city = list(map(int, input().split()))
    score[city.index(max(city))] += 1
print(score.index(max(score)) + 1)
{% endhighlight%}

### Arrays
[Source](http://codeforces.com/problemset/problem/572/A)

Choose the *k* smallest numbers from the first array and the *m* largest numbers from the second one. A single comparison can tell us the answer.

{% highlight python %}
input() # Useless first line

n,m = map(int, input().split())
a1 = list(map(int, input().split()))[:n]
a2 = list(map(int, input().split()))[-m:]

print("YES" if a1[-1] < a2[0] else "NO")
{% endhighlight %}

### Order Book
[Source](http://codeforces.com/problemset/problem/572/B)
This problem is similar to the previous one. Aggregate the buy and sell orders and sort in descending order. Take the *s* best ones (smallest sell orders and largest buy orders).

{% highlight python %}
n,s = map(int, input().split())

sell = {}
buy = {}

for i in range(n):
    type, price, vol = input().split()
    price = int(price)
    vol = int(vol)
    if type == 'S':
        sell[price] = sell.get(price, 0) + vol
    else:
        buy[price]  = buy.get(price, 0) + vol
for order in sorted(sell.items(), reverse = True )[-s:]:
    print("S", order[0], order[1])
for order in sorted(buy.items(), reverse = True )[:s]:
    print("B", order[0], order[1])
{% endhighlight %}


### Bear and Elections
[Source](http://codeforces.com/problemset/problem/574/A)

Steal a vote from the rival the with most votes until Limak has a sure win. A linear search for the best rival on each step or sorting the rivals' vote array is enough to solve the problem. A heap is also an option.

{% highlight python %}
import heapq

n = map(int, input().split())
votes = list(map(int, input().split()))

limak = votes[0]
votes = [-x for x in votes[1:]]
heapq.heapify(votes)

ans = 0
while limak <= -votes[0]:
    vote = -heapq.heappop(votes)
    vote -= 1
    limak += 1
    ans += 1
    heapq.heappush(votes, -vote)
print(ans)
{% endhighlight %}

### Multiplication Table
[Source](http://codeforces.com/problemset/problem/577/A)

*x* can appear once on each row *i* where the modulo between *x* and *i* is 0. Additionally, *x* will be present only if *x / i <= n* (we would count numbers outside of the table if we ignore this check).

{% highlight python %}
n,x = map(int, input().split())
ans = 0
for i in range(1, n + 1):
    if x % i == 0 and x / i <= n:
        ans+=1
print(ans)
{% endhighlight %}

### Conclusion

I've only used python for competitive programming and some scripting during my thesis project and I certainly do love how I don't need 20 ~ 30 lines of code only for reading and parsing input ♥.
