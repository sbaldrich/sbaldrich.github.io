---
layout: post
title: "Two-dimensional DP"
modified:
categories: comprog

tags: [300pch, dp]

date: 2015-10-18T20:01:45-05:00
---

Another couple of simple DP problems for today.

### ChessMetric
<a href="http://community.topcoder.com/stat?c=problem_statement&pm=1592&rd=4482" target="\_blank">Source</a>

The recursion is simple. The number of possible ways to reach cell \\((i, j)\\) in \\(k\\) moves is the sum of all possible ways to reach (in \\(k - 1\\) moves) all cells (\\(m, n\\)) from which (\\(i, j\\)) is reachable. It is possible to solve the problem without storing the board for all \\(k\\) moves, but it is not necessary to do so.

{% highlight c++ %}
#include <bits/stdc++.h>

using namespace std;

long long dp[55][105][105];

int dr[] = {-1, -2, -2, -1, 1, 2,  2,  1,  0, -1, -1, -1, 0, 1, 1,  1};
int dc[] = {-2, -1,  1,  2, 2, 1, -1, -2, -1, -1,  0,  1, 1, 1, 0, -1};

bool ok( int row, int col, int size ){
	return row < size && row >= 0 && col < size && col >= 0;
}

class ChessMetric {
public:
	long long howMany(int size, vector <int> start, vector <int> end, int moves) {
		for( int k = 0; k <= moves; k++ )
			for( int i = 0; i < size; i++ )
			 	for( int j = 0; j < size; j++ )
					dp[k][i][j] = 0LL;

		for( int i = 0, row, col; i < 16; i++ ){
			row = start[0] + dr[i];
			col = start[1] + dc[i];
			if( ok( row, col, size ) )
				dp[1][row][col] = 1LL;
		}

		for( int k = 2; k <= moves; k++ ){
			for( int i = 0; i < size; i++ ){
				for( int j = 0; j < size; j++ ){
					for( int l = 0, row, col; l < 16; l++ ){
						row = i + dr[l];
						col = j + dc[l];
						if( ok( row, col, size ) )
							dp[k][i][j] += dp[k-1][row][col];
					}
				}
			}
		}
		return dp[moves][end[0]][end[1]];
	}
};
{% endhighlight %}

### AvoidRoads
<a href="http://community.topcoder.com/stat?c=problem_statement&pm=1889&rd=4709" target="\_blank">Source</a>

The solution is similar to the problem above. For each cell, add the number of possible ways to reach the cells from which it is reachable. Before doing so, check whether the road can be used. **Pro tip: watch out for the coordinate system**.

{% highlight java%}
import java.util.*;

public class AvoidRoads{
	public long numWays(int width, int height, String[] bad){
		width++;
		height++;
		Set<String> block = new HashSet<>();
		for( String s : bad )
			block.add( s );
		long[][] dp = new long[height+1][width+1];
		dp[1][1] = 1;
		for( int i = 1; i <= height; i++ )
			for( int j = 1; j <= width; j++ ){
				if( can( i-1, j, i , j, block ) ) dp[i][j] += dp[i-1][j];
				if( can( i, j-1, i, j, block ) ) dp[i][j] += dp[i][j-1];
			}

		return dp[height][width];
	}

	boolean can( int i, int j, int k, int l, Set<String> block ){
		--i;--j;--k;--l;
		String s1 = String.format("%d %d %d %d", j, i, l, k), s2 = String.format( "%d %d %d %d", l, k, j, i);
        return !( block.contains( s1 ) || block.contains( s2 ) );
	}
}
{% endhighlight %}
