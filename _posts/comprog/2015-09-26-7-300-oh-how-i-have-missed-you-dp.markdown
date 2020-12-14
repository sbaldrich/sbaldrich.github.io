---
layout: post
title: "(7/300): Oh How I Have Missed You, DP"
modified:
categories: comprog

tags: []

date: 2015-09-26T19:43:05-05:00
---

I didn't have a lot of time to solve problems this week so I'm getting behind schedule. I must have
a "coding binge" soon.

### Kefa and Park
<a href="http://codeforces.com/contest/580/problem/C" target="_blank">source</a>

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

#### Bonus: C++ solution

{% highlight c++%}
#include<bits/stdc++.h>

#define MAX_N 100010
using namespace std;

vector<int> g[MAX_N];
bool cat[MAX_N];
int n, m;

int dfs(int node, int cats, int parent){
    if(cat[node] && cats == m)  return 0;
    if(g[node].size() == 1 && parent > 0) return 1;
    int ans = 0;
    for(int i = 0; i < g[node].size(); i++){
        if(g[node][i] != parent){
            ans += dfs(g[node][i], cat[node] ? cats + 1 : 0, node);
        }
    }
    return ans;
}

int main(){
    std::ios::sync_with_stdio(false);
    cin >> n >> m;
    for(int i = 1; i <= n; i++) { cin >> cat[i];}
    for(int i = 1, u, v; i < n; i++){
        cin >> u >> v;
        g[u].push_back(v);
        g[v].push_back(u);
    }
    cout << dfs(1, 0, 0) << endl;
    return 0;
}

{% endhighlight%}

### Little Elephant and T-Shirts
<a href="https://www.codechef.com/problems/TSHIRTS" target="_blank">source</a>

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

#### Bonus Python solution

{% highlight python %}
MOD = 1000000007
T = int(input())
SHIRTS = 101

for t in range(T):
    N = int(input())
    owns = [[False] * SHIRTS for _ in range(N)]
    for i in range(0, N):
        for s in map(int, input().split()):
            owns[i][s] = True
    dp = [[0] * (1 << N) for _ in range(SHIRTS)]
    dp[0][0] = 1

    for s in range(1, SHIRTS):
        for m in range(1 << N):
            dp[s][m] = dp[s - 1][m]
            for b in range(N):
                if m & (1 << b) and owns[b][s]:
                    dp[s][m] = (dp[s][m] + dp[s-1][m ^ (1 << b)]) % MOD
    print(dp[SHIRTS - 1][(1 << N) - 1])
{% endhighlight%}


### Kefa and Dishes
<a href="http://codeforces.com/contest/580/problem/D" target="_blank">source</a>

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

#### Bonus (TLE'd) Python solution

<small>I really tried to get a Python solution accepted, but so far it doesn't seem that anyone in Codeforces (including me) has been able to get past case 15 </small>

{% highlight python %}
def main():

    n, m, k = list(map(int, input().split()))
    a = list(map(int, input().split()))
    DISHES = 20
    r = [0] * DISHES * DISHES
    dp = [0] * n * (1 << n)

    for _ in range(k):
        f, t, s = list(map(int, input().split()))
        r[(f - 1) * DISHES + t - 1] = s

    ans = 0
    for mask in range(1 << n):
        for b in range(n):
            plate = 1 << b
            if mask & plate:
                dishes = 1
                wask = mask ^ plate
                if wask:
                    for i in range(n):
                        if wask & (1 << i):
                            dishes += 1
                            dp[mask * n + b] = max(dp[wask * n + i] + r[i * DISHES + b] + a[b], dp[mask * n + b])
                else:
                    dp[mask * n + b] = a[b]
                if m == dishes:
                    ans = max(ans, dp[mask * n + b])
    print(ans)

main()
{% endhighlight %}

### Finding Team Members
<a href="http://codeforces.com/contest/579/problem/B" target="_blank">source</a>

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
