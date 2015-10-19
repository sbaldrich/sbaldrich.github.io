---
layout: post
title: "(3/300): Three \"easy\" Problems"
modified:
categories: cp
excerpt:
tags: []
image:
  feature:
date: 2015-09-22T19:59:09-05:00
---

Three problems. Three languages. <del>Three</del> Two stupid mistakes.

### Raising Bacteria
<a href="http://codeforces.com/problemset/problem/579/A" target="_blank">Source</a>

Look at the problem in reverse and find out the minimum number of bacteria that should be removed to get to the origin. This corresponds to the number of times an odd number is obtained on successive divisions by 2 or the number of set bits on the binary representation of the initial number. **Fun fact:** The number of set bits is called a *population count* or the *Hamming weight*.

{% highlight c++ %}
#include <iostream>
using namespace std;

int main() {
    int n;
    cin >> n;
    cout << __builtin_popcount(n) << endl;
    return 0;
}
{% endhighlight %}

### Kefa and First Steps
<a href="http://codeforces.com/problemset/problem/580/A" target="_blank">Source</a>

Find the longest non-decreasing sub-segment, nothing to explain. *Stupid mistake:* I read *subsequence* the first time.

{% highlight java %}
import java.util.*;

public class Main{
  public static void main(String args[]){
    Scanner sc = new Scanner(System.in);
    int n = Integer.parseInt(sc.nextLine());
    int[] a = Arrays.stream(sc.nextLine().split("\\s+")).mapToInt(Integer :: parseInt).toArray();
    sc.close();
    int best = 1, current = 1;
    for(int i = 1; i < n; i++){
      if(a[i] >= a[i-1]){
        current++;
      }
      else{
        best = Math.max(best, current);
        current = 1;
      }
    }
    best = Math.max(best, current);
    System.out.println(best);
  }
}
{% endhighlight %}

### Kefa and Company

<a href="http://codeforces.com/problemset/problem/580/B" target="_blank">Source</a>.

Sort everyone by the amount of money they have. The answer now lies within a sub-segment, taking advantage of the initial sorting, check all the valid ones and return the one with the biggest friendship factor. *Stupid mistake:* I didn't check for differences of exactly *d* units.

{% highlight scala %}

object KefaAndCompany {
  def main(args : Array[String]) : Unit = {
    val sc = new java.util.Scanner(System.in)
    val (n,d) = (sc.nextInt(), sc.nextInt())
    var a = new Array[(Int,Int)](n)

    for( i <- 0 until n )
      a(i) = (sc.nextInt(), sc.nextInt())
    a = a.sortBy(_._1)

    var best = 0L
    var currentTotal = 0L
    var low = 0     

    for( i <- 0 until n ){
      currentTotal += a(i)._2
      while(low < i && math.abs(a(low)._1 - a(i)._1) >= d){
        currentTotal -= a(low)._2
        low += 1
      }
      best = math.max(currentTotal, best)
    }

    println(best)    
  }  
}

{% endhighlight %}

### WTF is that commit message?

I plan to parse and analyze (can you say **R**?) the commit messages later on to make sure that I fulfill the challenge's conditions.
