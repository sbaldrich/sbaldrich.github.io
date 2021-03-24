---
layout: post
title: 'Seeking Hamlet: Part I'
date: 2021-03-23 22:26 +0100
categories: blog
---

I've been playing around with Java's `nio` lately and ended up doing some simple experiments around [The Tragedy of Hamlet](https://gist.githubusercontent.com/provpup/2fc41686eab7400b796b/raw/b575bd01a58494dfddc1d6429ef0167e709abf9b/hamlet.txt). In a nutshell, I want to get the byte offsets for each word in the play, such that given a word, I can easily navigate to any of its locations in the file and do something there.

_Do what?_ you ask? I have no idea. That's something for my future self to think about when it's time to write the second part of this blog post.


### The Approach
<small>Keep in mind this is a very first draft, so the final code may end up looking quite different</small>

I'll take advantage of the file being comprised only of ascii characters. Additionally, words are being processed as if they were only composed of alphabetic chars, so the word `pardon't` will be split in two: `pardon` and `t`. I may look into ways of fixing this later but for now I don't see it as too big of an issue.  

The `Word` class represents a single word and is backed by a `byte[]`, also all chars are lowercased during the instantiation of a `Word`. For the actual file preprocessing, I read the file using `4Kb` blocks and extract the tokens looking for continuous subarrays of alphabetic characters. One thing to keep in mind when doing this, is that it is possible to get to the end of the read data while in the middle of a word, so this also has to be taken care of.  

### The Result

The program prints the found tokens and their locations in the file. This byte offset can be used to get quickly to that location in the file and do things like getting the context in which the word appears: 

```sh
> java SeekingHamlet

...
truth is present at locations: [8568, 27105, 45865, 54909, 56900, 157694]
try is present at locations: [56982, 57377, 98890, 110856, 122254, 134053]
tugging is present at locations: [123350]
tumbled is present at locations: [137178]
tune is present at locations: [86164, 180204]
tunes is present at locations: [155659, 165195]
turbulent is present at locations: [78513]
turf is present at locations: [135858]
turk is present at locations: [102215]
turn is present at locations: [47572, 74113, 82705, 99355, 102210, 110242, 117111, 142126, 146140, 166505, 179981, 187163]
turneth is present at locations: [147855]
turns is present at locations: [143499]
tush is present at locations: [2435, 2441]
tutor is present at locations: [88659]
twain is present at locations: [99941, 120469]
twas is present at locations: [67866, 70041, 70579, 167019]
tweaks is present at locations: [76685]
tween is present at locations: [173348]
twelve is present at locations: [1235, 21908, 29200, 96383, 179240]
...

> tail -c +78513 hamlet.txt | head -n 5 # navigate to the byte offset of 'turbulent' 
turbulent and dangerous lunacy?
  Ros. He does confess he feels himself distracted,
    But from what cause he will by no means speak.
  Guil. Nor do we find him forward to be sounded,
    But with a crafty madness keeps aloof
```

Get the code [here](https://github.com/sbaldrich/zoo/tree/master/seeking-hamlet).

Is this useful? no clue, but it is fun.
