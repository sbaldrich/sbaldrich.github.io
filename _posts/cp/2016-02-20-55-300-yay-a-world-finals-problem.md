---
layout: post
title: "(55/300): Yay! a World Finals Problem"
modified:
categories: cp
excerpt: ""
tags: [binary search, combinatorics, permutations, heaps algorithm]
image:
  feature:
date: 2016-02-20T13:15:39-05:00
---

*Hey! a world finals problem!* Arguably an easy one but nonetheless a world finals problem ^^.

### A Careful Approach
<a href="https://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=3520" target="\_blank">Source</a>

We are asked to find the *largest minimum time gap* between the airplane landings while respecting the time windows given for them. Since the number of planes is small (\\(8\\)), we can safely check all possible orderings (\\(8!\\)) of the landings looking for the maximum time gap. To find the gap, we can use a *binary search* and greedily check whether we can safely land the airplanes respecting a given gap. I decided to implement the solution in Java just to see whether I could do it without C++'s `next_permutation` and stumbled upon a beautiful algorithm to generate all the (unsorted) permutations of an array called **Heap's algorithm** (the link to its description is in the code).
I decided to put the search inside a `Consumer` to improve readability and to emphasize on how simple Heap's algorithm is.     

{% highlight java %}
import java.util.Scanner;
import java.util.Arrays;
import java.util.function.Consumer;
import java.util.stream.IntStream;
import static java.lang.Math.max;

public class ACarefulApproach{

  static int[] start = new int[10];
  static int[] end = new int[10];
  static int n;
  static double best;

  private static void swap(int[] array, int p, int q){
    int r = array[p];
    array[p] = array[q];
    array[q] = r;
  }
  /**
  * Generate all permutations (in no particular order) of the given array and
  * perform the action described by the consumer on each one.
  * See https://en.wikipedia.org/wiki/Heap%27s_algorithm
  */
  static void solve(int n, int[] perm, Consumer<int[]> f ){
    if(n == 1){
      f.accept( perm );
    }
    else{
      for(int i=0; i < n - 1; i++){
        solve( n-1, perm, f);
        swap(perm, n % 2 == 0 ? i : 0, n - 1);
      }
      solve( n-1, perm, f);
    }
  }

  static boolean possible( int order[], double time ){
    double next = start[order[0]] + time;
    for( int i = 1; i < order.length; i++ ){
      if( next > end[order[i]])
        return false;
      if( next < start[order[i]] )
        next = start[order[i]] + time;
      else next += time;
    }
    return true;
  }

  public static void main(String... args){
    Scanner sc = new Scanner(System.in);
    int tc = 0;
    while(( n = sc.nextInt() ) != 0){
      best = 0.0;
      for(int i=0; i < n; i++){
        start[i] = 60 * sc.nextInt();
        end[i] = 60 * sc.nextInt();
      }
      double EPS = 1e-9;
      final Consumer<int[]> search = ( int[] order ) -> {
        double hi = 1440 * 60, lo = 1, mid;
        while( hi - lo > EPS ){
          mid = ( lo + hi ) / 2.0;
          if( possible( order, mid ) ){
            best = max( best, mid );
            lo = mid;
          }
          else{
            hi = mid;
          }
        }
      };

      solve(n, IntStream.range(0, n).toArray(), search);
      long ans = Math.round(best);
      System.out.printf("Case %d: %d:%02d\n", ++tc, ans / 60, ans - ans / 60 * 60);
    }
  }
}

{% endhighlight %}

### Conclusion

`next_permutation` is no longer an excuse to not use Java for competitive programming ಠ_ಠ.
