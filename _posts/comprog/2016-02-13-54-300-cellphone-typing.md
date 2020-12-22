---
layout: post
title: "Cellphone Typing"
modified:
categories: comprog

tags: [trie, ds, LA2012, regional]

date: 2016-02-13T16:31:16-05:00
---

I solved this problem a while ago but since it uses a fundamental data structure, I figured it would be good to revisit it.

### Cellphone Typing
<a href="https://icpcarchive.ecs.baylor.edu/index.php?option=com_onlinejudge&Itemid=8&category=572&page=show_problem&problem=4144" target="\_blank">Source</a>

Hey! a regional problem. We're asked to find the average number of keystrokes required to type a word from a known dictionary in a cellphone. The problem screams and begs to be solved using a **trie**. By building a simple trie and storing the number of outgoing edges for each node, we can know the number of strokes (*didn't the last problem also have something to do with strokes?*) required for us to uniquely identify the word that is going to be written.

Watch out for the initial keystroke that must always be counted.

{%highlight java%}
import java.util.*;
import java.text.DecimalFormat;

public class CellphoneTyping{

  public static class Trie{
    boolean end;
    Trie[] next;
    int out = 0;

    Trie(){
      this(0);
    }
    private Trie(int c){
      next = new Trie[26];
    }

    Trie add(String word){
      return add(word.chars().map(c -> c - 'a').toArray(), 0);
    }

    private Trie add(int[] w, int i){
      if(i == w.length){
        end = true;
        return this;
      }
      if(next[w[i]] == null){
        next[w[i]] = new Trie(w[i]);
        out++;
      }
      return next[w[i]].add(w, i + 1);
    }

    int strokes(String word){
      return strokes(word.chars().map(c -> c - 'a').toArray(), 0, 0);
    }

    private int strokes(int[] w, int i, int s){
      if(i == w.length)
        return s;
      return s > 0 && out == 1 && !end ? next[w[i]].strokes(w, i+1, s) : next[w[i]].strokes(w, i+1, s+1);
    }

  }

  public static void main(String... args){
    Scanner sc = new Scanner(System.in);
    DecimalFormat df = new DecimalFormat("0.00");
    List<String> words = new ArrayList<>();
    while(sc.hasNext()){
      words.clear();
      int n = sc.nextInt();
      Trie t = new Trie();
      for(int i = 0; i < n; i++){
        String word = sc.next();
        words.add(word);
        t.add(word);
      }
      double ans = 0.0;
      for(String word : words)
        ans += t.strokes(word);
      System.out.println(df.format(ans / n));
    }
  }

}
{%endhighlight%}


### Conclusion

I really like this kind of problems were knowing about a particular data structure or algorithm is required to get to the solution.
