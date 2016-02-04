---
layout: post
title: "(51/300): This One Took a While"
modified:
categories: cp
excerpt: ""
tags: [combinatorics, dp]
image:
  feature:
date: 2016-01-30T09:50:34-05:00
---

A lot has happened and I haven't been able to dedicate as much time as I'd like to competitive programming. However, I'm still here so let's get started with the problem.

### Jewelry
<a href="https://community.topcoder.com/stat?c=problem_statement&pm=1166&rd=4705" target="\_blank">Source</a>

I spent a lot of time trying to solve this problem without any help but I couldn't so I relied on its [tutorial](https://community.topcoder.com/tc?module=Static&d1=match_editorials&d2=tco03_online_rd_4) and the discussion forums, which made the matter more of *understanding* the problem rather than *solving* it.

Given the conditions, we can think of the problem as a matter of sorting the jewels and finding the number of ways in which we can obtain the same sum by choosing from the first \\(i\\) jewels and the last \\(n - i\\) for all \\(i\\) and taking the product of these quantities. The aspect that makes the problem harder is that equal valued jewels must be treated as different, so all the different ways a group of equal valued jewels can be distributed between Frank and Bob must be taken into account. Then, the solution is as described above but processing jewels grouped by their values and using the binomial coefficients to take into account all possible distributions.

Check the <a href="https://github.com/sbaldrich/algo/wiki/Dynamic-Programming#prefsums" target="\_blank">subset sums</a> and <a href="https://github.com/sbaldrich/algo/wiki/Combinatorics#bin" target="\_blank">binomial coefficients</a> wikis for more info.

{% highlight java %}
import java.util.*;

public class Jewelry{

  int maxs = 1000 * 30;
  static final int maxe = 30;
  static long[][] C = new long[maxe + 1][maxe + 1]; // Binomial coefficients

  static {
    for(int i = 0; i <= maxe; i++){
      C[i][0] = 1;
      for( int j = 1; j <= i; j++ )
        C[i][j] = C[i - 1][j - 1] + C[i - 1][j];  
    }
  }

  long [][] prefSums = new long[maxs + 1][31]; // dp[s][i]: How many ways can I choose from the i first elements to make sum s?
  long [][] suffSums = new long[maxs + 1][31]; // dp[s][i]: How many ways can I choose from the i last elements to make sum s?

  public long howMany(int[] jewels){
    int n = jewels.length;
    Arrays.sort(jewels);
    prefSums[0][0] = suffSums[0][0] = 1;
    for(int s = 0; s <= maxs; s++){
      for(int i = 1; i <= n; i++){
        prefSums[s][i] = prefSums[s][i-1];
        if(s >= jewels[i - 1])
            prefSums[s][i] += prefSums[s - jewels[i-1]][i-1];
        suffSums[s][i] = suffSums[s][i-1];
        if(s >= jewels[n - i])
            suffSums[s][i] += suffSums[s - jewels[n-i]][i-1];
      }
    }

    long ans = 0;
    for(int i = 0; i < n; i++){
      int sz = 1;
      while(i + sz < n && jewels[i] == jewels[i + sz]) sz++;
      for(int j = i; j <= (i + sz - 1); j++){
        for(int s = (j - i + 1) * jewels[i]; s <= maxs; s++)
          ans += C[sz][j - i + 1] * prefSums[s - (j - i + 1) * jewels[i]][i] * suffSums[s][n - j - 1];
      }
      i += sz - 1;  
    }

    return ans;
  }
}

{% endhighlight %}

### Conclusion

I should try and find a balance in the difficulty of the problems so I don't spend too much time trying to solve a particular one nor solving too many easy ones.
