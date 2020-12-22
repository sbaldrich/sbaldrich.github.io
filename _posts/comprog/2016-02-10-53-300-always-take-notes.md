---
layout: post
title: "Always Take Notes"
modified:
categories: comprog
tags: []

date: 2016-02-10T20:13:41-05:00
---


Today worked on a *memoization* problem, which is kind of refreshing given that none of the DP solutions I've added to the blog were using it.

### StripePainter
<a href="https://community.topcoder.com/stat?c=problem_statement&pm=1215&rd=4555" target="\_blank">Source</a>

This is a rather hard problem that becomes easier once we find the proper states to use. Define a function \\(f(l,r,c)\\) that returns the minimum number of strokes that are needed to paint the tiles \\(l \to r\\) (\\(r\\) exclusive), given that they are currently painted with color \\(c\\). Now, one useful insight to solve the problem is that if the leftmost tile is already painted with the objective color, we don't need to consider it in the subproblems (the same happens with the rightmost tile). This is one of those problems that are easier to solve recursively rather than in a *bottom-up* DP manner.

{% highlight java %}

import java.util.*;
import static java.lang.Math.min;
public class StripePainter{

    char[] g;
    int memo[][][];

    int f(int l, int r, char c){ // Min. number of strokes needed to paint tiles [l,r)
                                 // with the desired color given that the current color is c
    	if( l >= r ) return 0;
    	if( memo[l][r][c] > 0 )
    		return memo[l][r][c];
    	if( g[l] == c ) return memo[l][r][c] = f(l+1, r, c);
    	if( g[r-1] == c ) return memo[l][r][c] = f(l, r-1, c);
    	int ans = 777;
    	for( int i= l + 1; i <= r; i++ )
    		ans = min( ans, 1 + f( l, i, g[l] ) + f( i, r, c ) );
    	return memo[l][r][c] = ans;
    }

    public int minStrokes(String stripes){
        memo = new int[51][51][100];
        g = stripes.toCharArray();
        return f(0, stripes.length(), '?');
    }
}

{% endhighlight %}

### Conclusion

One of the biggest difficulties related to using DP is finding the proper state to use. Finding it can be seen as somewhat of an art.
