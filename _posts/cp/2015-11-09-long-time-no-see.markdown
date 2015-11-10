---
layout: post
title: "(50/300): Long Time No See"
modified:
categories: cp
excerpt:
tags: [300pch, math, bits, greedy]
image:
  feature:
date: 2015-11-09T20:58:58-05:00
---

I'm back after a long break. This time there are some trivial problems and a couple of math related ones.

### The Monster and the Squirrel
<a href="http://codeforces.com/problemset/problem/592/B" target="\_blank">Source</a>

After the first vertex is processed, the polygon is divided in \\((n - 2)\\) regions. It can be seen (graphically) that each region is subsequently divided in \\((n - 2)\\) regions (except one). By adding the jump that the squirrel has to make in order to get into the polygon we get \\((n - 2) * (n-2)\\).

{% highlight python %}
n = int(input())
print ((n-2) ** 2)
{% endhighlight %}

### A Very Big Sum
<a href="https://www.hackerrank.com/challenges/a-very-big-sum" target="\_blank">Source</a>

mñeh.

{% highlight python %}
input()
print(sum(map(int, input().split())))
{% endhighlight %}

### Diagonal Difference
<a href="https://www.hackerrank.com/challenges/diagonal-difference" target="\_blank">Source</a>

You could store the whole matrix or simply accumulate the values of the diagonals that start from the left and right sides.

{% highlight python %}
n = int(input())
left, right = 0, 0
for i in range(n):
    row = list(map(int, input().split()))
    left += row[i]
    right += row[-i - 1]
diff = left - right
print((-1 if diff < 0 else 1) * diff)
{% endhighlight %}

### Plus Minus
<a href="https://www.hackerrank.com/challenges/plus-minus" target="\_blank">Source</a>

A perfect application for python.

{% highlight python %}
n = int(input())
nums = list(map(int, input().split()))
pos = sum(x > 0  for x in nums)
neg = sum(x < 0  for x in nums)
nul = sum(x == 0 for x in nums)
print(pos / n, neg / n, nul / n, sep = '\n')
{% endhighlight %}

### Simple Array Sum
<a href="https://www.hackerrank.com/challenges/simple-array-sum" target="\_blank">Source</a>

mñeh.

{% highlight java%}
import java.io.*;
import java.util.*;

public class Solution {

    public static void main(String[] args) throws IOException{
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        reader.readLine(); //Ignore the first line.
        int sum = Arrays.stream(reader.readLine().split("\\s+")).mapToInt(Integer :: valueOf).sum();
        System.out.println(sum);
    }
}
{% endhighlight %}

### Staircase
<a href="https://www.hackerrank.com/challenges/staircase" target="\_blank">Source</a>

Use loops or string format modifiers (such as python's "\{:>#\}").

{% highlight java%}
n = int(input())
for i in range(1, n + 1):
    print(("{:>" + str(n) + "s}").format("#" * i))
{% endhighlight %}

### Duff and Weight Lifting
<a href="http://codeforces.com/problemset/problem/588/C" target="\_blank">Source</a>

It can be seen that the answer is the number of set bits in the sum of weights. Since the sum can be absurdly large,
we should store its binary representation using an array and count the number of set bits in it.  

{% highlight java%}
import java.io.*;
import java.util.*;

public class DuffAndWeights{

  static int MAX_SIZE = (int)1e6 * 2 + 1;

  public static void main(String args[]) throws Exception{
    BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
    int n = Integer.valueOf(reader.readLine());
    int weights[] = Arrays.stream(reader.readLine().split("\\s+")).mapToInt(Integer :: valueOf).toArray();
    int sum[] = new int[MAX_SIZE];

    for(int w : weights){
      sum[w]++;
    }

    int ans = 0;
    for(int i = 0; i < MAX_SIZE - 1; i++){
      if(sum[i] > 1){
        sum[i + 1] += sum[i] / 2;
        sum[i] %= 2;
      }
      if(sum[i] == 1){
        ans++;
      }
    }

    System.out.println(ans);
  }
}
{% endhighlight %}

### Duff in Love
<a href="http://codeforces.com/problemset/problem/588/B" target="\_blank">Source</a>

The answer is the product of all prime divisors of \\(n\\).

{% highlight python%}
n = int(input())
ans = 1
f = 2
while f * f <= n:
    if(n % f == 0):
        ans *= f
        while(n % f == 0):
            n //= f
    f += 1
if(n > 1):
    ans *= n
print(ans)
{% endhighlight %}

### Duff and Meat
<a href="http://codeforces.com/problemset/problem/588/A" target="\_blank">Source</a>

Greedy. For each day, pay the cheapest price seen so far for the necessary meat.

{% highlight python%}
n = int(input())
ans = 0
cheapest = 1000
for i in range(n):
    needed, price = map(int, input().split())
    cheapest = min(cheapest, price)
    ans += cheapest * needed
print(ans)
{% endhighlight %}

### SetPartialOrder
<a href="https://community.topcoder.com/stat?c=problem_statement&pm=14075" target="\_blank">Source</a>

Simple set operations. Use your language.

{% highlight python%}
class SetPartialOrder:
    def compareSets(self, a, b):
        a = set(a)
        b = set(b)
        if(a <= b and b <= a):
            return "EQUAL"
        if(a <= b):
            return "LESS"
        if(b <= a):
            return "GREATER"
        return "INCOMPARABLE"
{% endhighlight %}

### SubstitutionCipher
<a href="https://community.topcoder.com/stat?c=problem_statement&pm=14074&rd=16552" target="\_blank">Source</a>

Implementation. Simply map letters using the given strings, if we've mapped 25 letters, we can easily find the missing letter.

{% highlight python%}

import string

class SubstitutionCipher:
    def decode(self, a, b, y):
        table = {}
        for c, d in zip(a, b):
            prev = table.get(d, '.')
            if(prev != '.' and prev != c):
                return ''
            table[d] = c
        ans = ''

        if(len(table) == 25):
            alpha = set(string.ascii_uppercase)
            s = (alpha - set(table.values())).pop()
            t = (alpha - set(table.keys())).pop()
            table[t] = s

        for c in y:
            nxt = table.get(c, '.')
            if(nxt == '.'):
                return ''
            ans += table[c]

        return ans

{% endhighlight %}
### Conclusion

I've decided it is not worth to code 300 problems just for the sake of it, solving a thousand easy problems is not as valuable as solving two hundred hard ones. Therefore, I'll work on harder problems from now on.
