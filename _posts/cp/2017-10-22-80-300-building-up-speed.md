---
layout: post
title: "(80/300): Building Up Speed"
modified:
categories: cp
excerpt: ""
tags: [python, c++, warmup, ad-hoc]
image:
  feature:
date: 2017-10-22T15:35:30-05:00
---

I spent some time working on regaining speed and setting up my competition environment –_I formatted my machine after getting
a new SSD_– today's problems are very simple but allowed me to remember some things I had not used in a while; I even had a hard
time reimplementing a solution to the `Kefa and Park` problem using C++. 

As a bonus, I found out that XCode is a pretty decent C++ IDE for competing, so I guess I'll be using it more from now on.
If you find yourself wanting to use it but can't get `<bits/stdc++.h>` to work, it is because XCode isn't using GCC anymore,
so you must add the header file by yourself to XCode's header directory 
route. See more <a href="https://stackoverflow.com/a/43028792/1898695" target="_blank">here</a>.

### Apple and Orange
<a href="https://www.hackerrank.com/challenges/apple-and-orange" target="_blank">source</a>

Check whether the falling location of each apple/orange is between the bounds of the house.

{% highlight python %}
s, t = list(map(int, input().split()))
a, b = list(map(int, input().split()))
m, n = list(map(int, input().split()))
apples = [x + a for x in list(map(int, input().split()))]
oranges = [x + b for x in list(map(int, input().split()))]

print(sum(s <= i <= t for i in apples))
print(sum(s <= i <= t for i in oranges))
{% endhighlight %}

### Day of the Programmer
<a href="https://www.hackerrank.com/challenges/day-of-the-programmer" target="_blank">source</a>

The only special case happens when the given year is \\( 1918 \\), compute it and the rest is a piece of cake. The answer is September 12 on leap years and 13 in non-leap ones no matter the type of calendar used. 

{% highlight python %}
def leap(y):
    if y <= 1917:
        return y % 4 == 0
    else:
        return y % 400 == 0 or (y % 4 == 0 and y % 100 != 0)


y = int(input())
print('26.09.1918' if y == 1918 else '{}.09.{}'.format(12 if leap(y) else 13, y))
{% endhighlight %}


### Divisible Sum Pairs
<a href="https://www.hackerrank.com/challenges/divisible-sum-pairs" target="_blank">source</a>

The simple \\( O(n^2) \\) is enough to solve the problem due to its constraints. If you want, spice the solution up using overly complicated functions just as I did. 

{% highlight python %}

from itertools import combinations

n, k = map(int, input().split())
a = map(int, input().split())

print(len([(x, y) for x, y in combinations(enumerate(a), 2) if x[0] < y[0] and (x[1] + y[1]) % k == 0]))
{% endhighlight %}


### Grading Students
<a href="https://www.hackerrank.com/challenges/grading" target="_blank">source</a>

We can find \\(n\\)'s closest multiple of five using the modulo operator (\\(n + 5 - (n % 5)\\)). To only round the grade up when the difference is less than 3 we
check that the modulo is greater or equal to 3.   

{% highlight c++ %}
#include<bits/stdc++.h>

using namespace std;

int main(){
	std::ios::sync_with_stdio(false);
	int n, g;
	cin >> n;
	while(n--){
		cin >> g;
		cout << (g < 38 ? g : g + (g % 5 >= 3 ? 5 - g % 5 : 0)) << endl;
	}
	return 0;
}
{% endhighlight %}


### Migratory Birds
<a href="https://www.hackerrank.com/challenges/migratory-birds" target="_blank">source</a>

Count the number of times each bird has been seen and return the id of the first bird with the maximum amount of appearances. 
C++'s `max_element` does just this, so my solution is based on it. 

{% highlight c++ %}
#include<bits/stdc++.h>

using namespace std;

int a[5], n;
int main(){
    std::ios::sync_with_stdio(false);
    cin >> n;
    for(int i = 0, x; i < n; i++) cin >>x, a[x - 1]++;
    cout << (max_element(a, a + 5) - a) + 1 << endl;
    return 0;
}
{% endhighlight %}

## Some Last Words

* Don't fear using pointer arithmetic. 



