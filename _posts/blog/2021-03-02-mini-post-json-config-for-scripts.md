---
layout: post
title: 'Mini post: JSON config for scripts'
date: 2021-03-02 21:46 +0100
categories: blog
---

Have you ever wondered if it is possible to configure a script using a json file? Me neither!

It seems to be possible using `jq`. You just need to parse the configuration file and use the read variables in your script:

```json
{
    "message" : "Hello World!",
    "times" : 3
}
```
<small>config.json</small>

```sh
export CONFIGFILE=config.json
message=$(jq -r '.message' $CONFIGFILE)
times=$(jq -r '.times' $CONFIGFILE)

for i in $(seq 1 $times); do
    echo $message
done
```
<small>script.sh</small>

With a setup like this, you can alter the behavior of the script by modifying its configuration:

```sh
> chmod +x ./script.sh
> .script.sh | nl

     1	Hello World!
     2	Hello World!
     3	Hello World!

> sed -i "s/Hello/Bye/g;s/3/6/g" config.json
> script.sh | nl

     1	Bye World!
     2	Bye World!
     3	Bye World!
     4	Bye World!
     5	Bye World!
     6	Bye World!
```

Is this useful? I don't know (ಠ_ಠ). Also, take a look a this great [intro to jq](https://programminghistorian.org/en/lessons/json-and-jq) I found some time ago.

