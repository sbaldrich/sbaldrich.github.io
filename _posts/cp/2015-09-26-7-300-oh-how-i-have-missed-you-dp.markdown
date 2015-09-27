---
layout: post
title: "(7/300): Oh How I Have Missed You, DP"
modified:
categories: cp
excerpt:
tags: []
image:
  feature:
date: 2015-09-26T19:43:05-05:00
---

I didn't have a lot of time to solve problems this week so I'm getting behind schedule. I must have
a "coding binge" soon.

### Kefa and Park
[source](http://codeforces.com/contest/580/problem/C)

A simple *dfs* that keeps track of the number of (consecutive) cats seen up to each node is enough to solve this problem.

{% highlight java %}

import java.util.*;

public class KefaAndPark {

  static ArrayList<ArrayList<Integer>> graph;
  static boolean hasCat[];
  static int n, m;

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    n = sc.nextInt();
    m = sc.nextInt();

    graph = new ArrayList<ArrayList<Integer>>();
    hasCat = new boolean[n];

    for(int i=0; i < n; i++){
      hasCat[i] = sc.nextInt() == 1;
      graph.add(new ArrayList<Integer>());
    }

    for(int i=0, u, v; i < n - 1; i++){
      u = sc.nextInt() - 1;
      v = sc.nextInt() - 1;
      graph.get(u).add(v);
      graph.get(v).add(u);
    }
    sc.close();
    System.out.println(dfs(0, 0, -1));
  }

  static int dfs(int p, int catcount, int parent){
    if(catcount == m && hasCat[p])
      return 0;
    if(parent != -1 && graph.get(p).size() == 1)
      return 1;
    int answer = 0;
    for(int child : graph.get(p))
      if(child != parent)
        answer += dfs(child, (hasCat[p] ? catcount + 1 : 0), p);
    return answer;
  }
}
{% endhighlight %}

### Little Elephant and T-Shirts
[source](https://www.codechef.com/problems/TSHIRTS)

This is a *must-solve* problem for anyone trying to learn how to use bitmasks to handle states with Dynamic Programming. The *dp* table keeps track of the number of ways we can select the t-shirts given that we have already processed shirts 1 up to *i* and we're in the state described by the mask (bit *i* set means person *i* already has a t-shirt).

{% highlight java %}
import java.util.*;

public class TSHIRTS {

  static final int SHIRTS = 101;
  static final int MAX_N = 11;
  static final long MOD = (long) (1e9 + 7);
  static long dp[][] = new long[SHIRTS][(1 << MAX_N)];
  static boolean owns[][] = new boolean[SHIRTS][MAX_N];

  public static void main(String args[]) {
    Scanner sc = new Scanner(System.in);
    int cases = Integer.parseInt(sc.nextLine());
    while (cases-- > 0) {
      int n = Integer.parseInt(sc.nextLine());
      for (boolean[] sh : owns)
        Arrays.fill(sh, false);

      for (int i = 0; i < n; i++) {
        String tmp[] = sc.nextLine().split("\\s+");
        for (String sh : tmp)
          owns[Integer.parseInt(sh)][i] = true;
      }

      dp[0][0] = 1;
      for (int s = 1; s < SHIRTS; s++) {
        for (int m = 0; m < (1 << n); m++) {
          dp[s][m] = dp[s - 1][m];
          for (int j = 0; j < n; j++) {
            if (owns[s][j] && (m & (1 << j)) != 0) {
              dp[s][m] = (dp[s][m] + dp[s - 1][m ^ (1 << j)]) % MOD;
            }
          }
        }
      }

      System.out.println(dp[SHIRTS - 1][(1 << n) - 1]);
    }
    sc.close();
  }
}
{% endhighlight %}

### Kefa and Dishes
[source](http://codeforces.com/contest/580/problem/D)

Another *DP + bitmasks* problem. This time the *dp(m,j)* table holds the maximum satisfaction Kefa can obtain given that the dishes described by the mask *m* have been taken and *j* is the last dish taken.

{% highlight java%}
import java.io.*;

public class KefaAndDishes {
  static int DISHES = 18;
  static long[][] dp = new long[1 << DISHES][DISHES];
  static long dish[] = new long[DISHES];
  static long boost[][] = new long[DISHES][DISHES];
  static BufferedReader in;
  static String pars[];
  static int n, m, k;

  public static void main(String[] args) throws IOException {
    in = new BufferedReader(new InputStreamReader(System.in));
    pars = readLine();

    n = Integer.valueOf(pars[0]);
    m = Integer.valueOf(pars[1]);
    k = Integer.valueOf(pars[2]);

    pars = readLine();
    for (int i = 0; i < n; i++)
      dish[i] = Integer.valueOf(pars[i]);

    for (int i = 0, from, to, gain; i < k; i++) {
      pars = readLine();
      from = Integer.valueOf(pars[0]);
      to = Integer.valueOf(pars[1]);
      gain = Integer.valueOf(pars[2]);
      boost[from - 1][to - 1] = gain;
    }

    long ans = Integer.MIN_VALUE;

    for (int mask = 0; mask < (1 << n); mask++) {
      for (int i = 0; i < n; i++) {
        if ((mask & (1 << i)) == 0)
          continue;
        if (Integer.bitCount(mask) == 1) {
          dp[mask][i] = dish[i];
        } else {
          for (int j = 0; j < n; j++) {
            if (i != j && (mask & (1 << j)) != 0)
              dp[mask][i] = Math.max(dp[mask ^ (1 << i)][j] + boost[j][i]
                  + dish[i], dp[mask][i]);
          }
        }
        if (Integer.bitCount(mask) == m)
          ans = Math.max(ans, dp[mask][i]);
      }
    }

    System.out.println(ans);
  }

  private static String[] readLine() throws IOException {
    return in.readLine().split("\\s+");
  }
}
{% endhighlight %}

### Finding Team Members
[source](http://codeforces.com/contest/579/problem/B)

Greedy. Sort all the given teams in descending order by strength and keep taking the best one still possible on each step.

{% highlight java%}
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.TreeSet;

public class FindingTeamMembers {

  static BufferedReader in;
  static String pars[];
  static int n;
  static TreeSet<Team> teams = new TreeSet<>();

  public static void main(String[] args) throws IOException {
    in = new BufferedReader(new InputStreamReader(System.in));
    readLine();
    int n = Integer.valueOf(pars[0]);
    int ans[] = new int[2*n];
    Arrays.fill(ans, -1);
    for (int i = 1; i <= 2 * n - 1; i++) {
      readLine();
      for (int j = 0; j < i; j++) {
        teams.add(new Team(j, i, Integer.valueOf(pars[j])));
      }
    }
    for (Team team : teams) {
      if(ans[team.memberA] == -1 && ans[team.memberB] == -1){
        ans[team.memberA] = team.memberB;
        ans[team.memberB] = team.memberA;
      }
    }
    for(int i = 0; i < 2*n; i++)
      System.out.print((i > 0 ? " " : "") + (ans[i] + 1) + (i == 2*n-1 ? "\n" : ""));

  }

  private static class Team implements Comparable<Team> {
    int memberA;
    int memberB;
    int strength;

    public Team(int memberA, int memberB, int strength) {
      this.memberA = memberA;
      this.memberB = memberB;
      this.strength = strength;
    }

    @Override
    public int compareTo(Team that) {
      return that.strength - this.strength;
    }

    @Override
    public String toString() {
      return String.format("[%d %d] = %d", memberA, memberB, strength);
    }
  }

  static void readLine() throws IOException {
    pars = in.readLine().split("\\s+");
  }
}
{% endhighlight %}

### Conclusion

I must keep doing DP problems. I'm very rusty.
