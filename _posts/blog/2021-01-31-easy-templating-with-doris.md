---
layout: post
title: Easy Templating with Doris
categories: blog
date: 2021-01-31 13:33 +0100
---

A big chunk of my day is spent interacting with different databases, remote hosts and independent applications. This means I sometimes have to run one-off queries or commands that are not part of any pipeline. 

These queries and commands often take the form of scripts and notes I have organized in a directory tree that I go to whenever I need to grab something. The problem with this approach is that the queries and commands are not always the same: I don't always have to interact with the *same* host, or compute summaries for the *same dates*. My commands are basically templates that I modify according to the situation, but **each modification brings with it the risk of making a permanent change on something that should be kept instance agnostic**. 

With this in mind and a free afternoon, can I hack something quickly enough to see a reasonable return on the investment?

#### Wish List:
    
- I can't use anything that's not already installed in my system (for security reasons I shouldn't install third-party software) (this would've been way easier if I could only use `envsubst`, which is not part of OSX by default)
- Should be faster and safer to use than the current approach.
- I should be able to easily see how a template is structured.
- Adding new templates should be easy.
- Finding a specific template to use should be fast.
    
## Meet Doris

Doris is structured as a single script (with completions) that lives next to a template directory. Template files can take any form and may use environment variables inside them:

```sql
SELECT count(*) 
  FROM warehouse.products 
 WHERE product_type = '$PRODTYPE'
   AND store_id=$STOREID
```
<small>Sample template for a simple sql query</small>

So if I define the PRODTYPE and STOREID environment variables as 'doomsday equipment' and 42 respectively, I'd get the following.

```sql
SELECT count(*) 
FROM warehouse.products 
WHERE product_type = 'doomsday equipment'
AND store_id=42
```

To make the workflow better, the `show` sub-command displays the structure of the template with variables highlighted. 
I also added a flag to `--copy` the output to the clipboard as I'm often sharing these one-off commands with teammates. It's easy to extend doris to directly evaluate the rendered template instead of copying it to the clipboard, so I'll probably pick that up next.

In the end, something like the following is possible: 


![doris-01](/figs/doris-01.gif)

Way faster and safer than the *copy, modify, execute* flow I had before.

Finally, a cool consequence of the way templates are rendered, is that I can use default values for the variables, so not everything has to be defined everytime I want to use a template.

See for example the following excerpt from a 90's family movie, we could render the template as is or use the `FIRST` and `SECOND` environment vars to modify the text.
```sh
Normally, both your asses would be dead as fucking fried chicken,
but you happen to pull this shit while I'm in a transitional period
so I don't wanna ${FIRST:-kill} you, I wanna ${SECOND:-help} you.
But I can't give you this case, it don't belong to me.
Besides, I've already been through too much shit this morning over
this case to hand it over to your dumb ass.

```

Check out the code [here](https://github.com/sbaldrich/zoo/tree/master/doris).
