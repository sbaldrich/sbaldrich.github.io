---
layout: post
title: "(81/300): A Bonus Classic DP"
modified:
categories: comprog

tags: [dp, c++]

date: 2017-10-22T16:54:13-05:00
---

Just before logging off for the day I saw this problem on someone else's feed. Since it clearly screamed to be an LCS problem
I thought "_what the heck, let's solve it_".

### Common Child
<a href="https://www.hackerrank.com/challenges/common-child" target="_blank">source</a>

Oh, the classic LCS. 

Let \\(S\\) and \\(T\\) be the first and second strings and \\(S_i\\) represent the \\(i\\)-th character in string \\(S\\),
we can define our recursive solution as follows:
  
  * \\(if S_j = T_i \Rightarrow lcs(i, j) = lcs(i - 1, j - 1) + 1\\)
  * \\(if S_j \neq T_i \Rightarrow lcs(i, j) = \max(lcs(i - 1, j), lcs(i, j - 1))\\)

In other words, if we look at the last characters of both strings we have only three possibilities:
  
  * The characters match, so we can add 1 to our answer and remove them both.
  * We remove the last character from \\(S\\) and look for the LCS of \\(S'\\) and \\(T\\).
  * We remove the last character from \\(T\\) and look for the LCS of \\(S\\) and \\(T'\\).

The rest is simply a matter of implementing the bottom-up solution.

<small>**Note:** I tried submitting a memoized recursive solution afterwards but it TLE'd in a couple of cases</small>

{% highlight c++%}
#include<bits/stdc++.h>

using namespace std;

#define N 5010
#define max(x,y) x >= y ? x : y

int dp[N][N];

int main(){
    ios::sync_with_stdio(false);
    string s,t;
    cin >> s >> t;
    int n = (int)s.length();
    for(int i = 1; i <= n; i++){
        for(int j = 1; j <= n; j++){
            if(s[i-1] == t[j-1])
                dp[i][j] = dp[i-1][j-1] + 1;
            else dp[i][j] = max(dp[i][j-1], dp[i-1][j]);
        }
    }
    cout << dp[n][n] << endl;
    return 0;
}
{% endhighlight%}


