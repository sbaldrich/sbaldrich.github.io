---
layout: post
title: Parsing Bash Options Like a Champ
modified:
categories: blog
excerpt: ""
tags: [bash, scripting, getopts]
image:
  feature:
date: 2016-02-18T18:22:15-05:00
---

Say we want to create a script _parrot.sh_ whose sole purpose in this world is to echo every argument that is passed to it:

{% highlight bash %}
#!/bin/bash
# parrot.sh: Output all given arguments. If no argument is given, print nothing.
[[ $# -gt 0 ]] && echo $@
{% endhighlight %}

![parrot-2](/images/posts/parrot-1.png)

Easy, huh? But I find this parrot boring, so let's now say we want to be able to choose the color of the output. We could accomplish this by using the first argument as the color selector and the rest of the arguments as the string to be echoed.

{% highlight bash %}
#!/bin/bash
# parrot.sh: Output all given arguments with an optional color. If no argument is given, print nothing.

colors=(red green yellow blue)
color(){
    case "$1" in
        red)
            tput setaf 1
            ;;
        green)
            tput setaf 2
            ;;
        yellow)
            tput setaf 3
            ;;
        blue)
            tput setaf 4
            ;;
        *)
    esac
}

if [[ " ${colors[@]} " =~ $1 ]]; then
  color $1 && echo "${@:2:$#}"
else
  echo $@
fi

{% endhighlight %}

Since we might still want to use `parrot` without colored output, the script first checks whether the first argument is an actual color and if it isn't, the argument is echoed normally. Let's test the new script:

![parrot-3](/images/posts/parrot-3.png)

*Oh*, there is a problem. The output is clearly not what is intended whenever we want to output a phrase that starts with a word that could be interpreted as a color. We could add a sentinel value to the color array but it seems quite *hacky*. Additionally, what if we wanted to add another another functionality, such as word replacing or printing every argument in uppercase? Clearly this script could get out of control really fast.

### Enter `getopts`

Go and give <a href="http://wiki.bash-hackers.org/howto/getopts_tutorial" target="\_blank">this article</a> a quick read and come back. It's ok, I'll wait.

Using `getopts` we can easily define and parse the arguments given to our script. If you read the article, you now know that we can define an option for the color and stop worrying about the corner cases such as phrases that begin with our sentinel, so let's update our parrot script with this new tool.

{% highlight bash %}
#!/bin/bash
# parrot.sh: Output all given arguments with an optional color. If no argument is given, print nothing.

# ... the color function is defined as before

usage(){
  echo "usage: parrot.sh [-c color] words"
}

while getopts ":c:" opt; do
  case $opt in
    c)
      [[ " ${colors[@]} " =~ " $OPTARG " ]] && COLOR=$OPTARG
    ;;
    *)
      usage
      exit 1
  esac
done

shift $((OPTIND - 1)) # Now $1 refers to the first non-option
[[ $# -gt 0 ]] && color "$COLOR" && echo "$@"
{% endhighlight %}

In this new version, we can pass a `-c` option to the script to choose the color and we're back to printing all the *non-option* arguments as we did in our first version. Pay attention to the `shift` command, if we weren't using it, we'd echo all arguments (including options). Additionally, a `usage` message has been added to let clients know how to use the script. The `":c:"` string passed to `getopts` enables the *fail-silent* mode (no error messages are output by `getopts`) and defines an option `-c` that takes a mandatory argument.

![parrot-4](/images/posts/parrot-4.png)

Finally, let's say we want to add an option to output our phrase using uppercase. Now that we know how to use `getopts` it is only a matter of adding the new option to the `case` statement and using `tr` to modify our arguments. **Note:** *I'm using the version of bash that came preinstalled with El Capitan and the `${var^^}` option to change a string into uppercase isn't working, ergo, I had to use `tr`.*

The updated version of our parrot script follows:

{%highlight bash%}
#!/bin/bash

usage(){
  echo "usage: parrot.sh [-c color] [-u] words"
}

color(){
    case "$1" in
        red)
            tput setaf 1
            ;;
        green)
            tput setaf 2
            ;;
        yellow)
            tput setaf 3
            ;;
        blue)
            tput setaf 4
            ;;
        *)
    esac
}
colors=(red green yellow blue)

while getopts ":c:u" opt; do
  case $opt in
    c)
      [[ " ${colors[@]} " =~ " $OPTARG " ]] && COLOR=$OPTARG
    ;;
    u)
      UPPER=1
    ;;
    *)
      usage
      exit 1
  esac
done

shift $((OPTIND - 1)) # Now $1 refers to the first non-option
[[ $# -eq 0 ]] && exit
ret=$@
[[ "$UPPER" == "1" ]] && ret=`echo $ret | tr [[:lower:]] [[:upper:]]`
color "$COLOR" && echo "$ret"
{%endhighlight%}

We can now mix our options as we like:

![parrot-5](/images/posts/parrot-5.png)

### Conclusion

Using `getopts` can greatly simplify the use of options in our scripts and functions. It is a *must-have* in the tool belt of every bash ninja.
