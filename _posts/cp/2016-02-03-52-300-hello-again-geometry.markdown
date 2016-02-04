---
layout: post
title: "(52/300): Hello Again, Geometry"
modified:
categories: cp
excerpt: ""
tags: [geometry, math, gcd]
image:
  feature:
date: 2016-02-03T18:45:33-05:00
---

This problem arose a couple of months ago in a competition at work. I promised I'd work on it, so here it is.

### Ancient Berland Circus
<a href="http://codeforces.com/problemset/problem/1/C" target="\_blank">Source</a>

*"Ugh, geometry"*. Although this might be the first thing one could think when encountering a problem like this in a competition, it turns out to have some nice solutions and a pretty awful one. The awful one consist in finding the circumcenter \\( C \\) of the given triangle and calculating the angles formed by the line segments from \\(C \\) to each of the known vertices. After this, using the observation that the size of all known angles should be multiple of \\( \frac{2*\\pi}{n} \\), iterate over \\(n\\) until a suitable values is found (the fact that \\(\sin(x) = 0\\)) for \\(x\\) multiple of \\(\pi\\) can also be used.

*Wow, I don't feel like coding that solution at all*. A much nicer solution (and the one I've implemented) goes as this: Let \\(a, b\\) and \\(c\\) be the given points and \\(A, B, C\\) be the inner angles of \\(\bigtriangleup abc\\) (\\(A\\) is the angle opposite to point \\(a\\), \\(B\\) and \\(C\\) likewise). Find the circumradius using both [Heron's Formula and the area in terms of the circumradius formula](https://github.com/sbaldrich/algo/wiki/Geometry) (*no perpendicular bisectors, cool!*) and using the law of cosines, get \\(A, B\\) and \\( C\\). Finally, our \\(n\\) can be found as \\( \frac{\pi}{gcd(A,B,C)}\\) , which gives us all the information necessary to plug it into the formula for getting the area of a regular polygon. I'm aware this solution seems complicated but take a look at the code and it will seem much better:

{% highlight java %}
import static java.lang.Math.*;
import java.util.*;
import java.text.DecimalFormat;

public class AncientBerlandCircus{

  static final double EPS = 1e-4;
  static final DecimalFormat df = new DecimalFormat("0.000000");
  static double dist(double x1, double y1, double x2, double y2){
    return sqrt( (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) );
  }

  static double gcd(double a, double b){
    while(abs(a) > EPS && abs(b) > EPS){
      if(a > b)
        a -= floor(a / b) * b;
      else
        b -= floor(b / a) * a;
    }
    return a + b;
  }

  public static void main(String[] args){
    double x1, x2, x3, y1, y2, y3;
    Scanner sc = new Scanner( System.in );
    x1 = sc.nextDouble();  y1 = sc.nextDouble();
    x2 = sc.nextDouble();  y2 = sc.nextDouble();
    x3 = sc.nextDouble();  y3 = sc.nextDouble();

    double a, b, c, s, S, R, A, B, C;
    // s: Heron's formula s to find the area of a triangle
    // S: Triangle area
    // R: Circumradius
    // a, b, c: triangle sides
    // A, B, C: Angles. Obtained from cosine law
    a = dist(x2, y2, x3, y3);
    b = dist(x1, y1, x3, y3);
    c = dist(x1, y1, x2, y2);

    s = (a + b + c) / 2.0;
    S = sqrt(s * (s - a) * (s - b) * (s - c) );
    R = a * b * c / (4.0 * S);
    A = acos((b * b + c * c - a * a) / (2.0 * b * c) );
    B = acos((a * a + c * c - b * b) / (2.0 * a * c) );
    C = acos((a * a + b * b - c * c) / (2.0 * a * b) );
    //n is the number of sides in the regular polygon we are looking for
    double n = PI / gcd( gcd( A, B ), C );
    double area = n * R * R * sin(2 * PI / n) / 2.0;
    System.out.println(df.format(area));
  }
}

{% endhighlight %}

### Conclusion

I usually don't like geometry problems because there are many small details that one should take care of (collinear points, precision errors, radians and not degrees, etc.) but this one was very entertaining.

***PS:** I didn't come up with this solution myself; in fact, I had to spend a couple of days relearning my high-school geometry to understand it.*
