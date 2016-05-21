---
layout: post
title: Exploratory Analysis of Shitty Tweets
modified:
categories: blog
excerpt: ""
tags: []
image:
  feature:
date: 2016-05-16T20:08:13-05:00
---

I finally had the chance of start working with R again and figured that analyzing my tweet archive would be a nice way of refreshing my skills. Although in the past it was necessary to parse JSON, Twitter now gives you a nice `tweets.csv` file containing all your tweets. Cool.

While googling for information on how to do this, I stumbled upon [Julia Silge's blog](http://juliasilge.com/blog/Ten-Thousand-Tweets/) (who coincidently also uses the [So-Simple](https://mmistakes.github.io/so-simple-theme/) theme for her blog) and found that she had done most of what I wanted to do with my tweets, so this analysis is heavily based on hers.

{% highlight R %}

library(dplyr)
library(ggplot2)
library(lubridate)
library(scales)

tw <- read.csv("tweets.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

{% endhighlight %}  

### Preprocessing

I used to talk to myself a lot (both in Twitter and real life), so I chose to separate tweets between "real" tweets, retweets, replies, and replies to myself. To do this, I got my Twitter id and simply checked whether the user I'm replying to is me or not.

{% highlight R %}

own.id <- 271769778 # yup, that's me.
tw$timestamp <- ymd_hms(tw$timestamp)
tw$type <- "tweet"
tw[(!is.na(tw$in_reply_to_status_id)),"type"] <- "reply"
tw[(!is.na(tw$in_reply_to_status_id) & (tw$in_reply_to_user_id == own.id)),"type"] <- "r.self"
tw[(!is.na(tw$retweeted_status_id)),"type"] <- "RT"
tw[(tw$type == "tweet") & grepl("@", tw$text), "type"] <- "mention"   #Not a bulletproof aproach but good enough for this analysis
tw$type <- as.factor(tw$type)
tw$type <- factor(tw$type, levels(tw$type)[5:1])

{% endhighlight %}

## Some Basic Twitter Behavior

#### All time

How does the frequency of my tweeting behave between 2011 and the end of 2015? (I haven't tweeted since Dec 2015 because reasons). Let's build some graphs using the wonderful `ggplot` and explore this a bit. I used `theme_set(theme_gray(base_size = 14))` to make the text in the graphs bigger.

{% highlight R %}

ggplot(tw, aes(timestamp)) +
geom_histogram(aes(fill = ..count..), bins = 60) +
xlab("Time") + ylab("Number of Tweets")

{% endhighlight %}

![freq-tweets-all-time](/figs/2016-05-22-exploratory-analysis-shitty-tweets/1-freq-tweets-all-time.png)

It seems I started tweeting a lot in the end of 2014 and had a couple of months off in 2015.  This seems reasonable since I started working during the night on my thesis document and Twitter was a good way of keeping me awake. I also seem to have taken whole months off in 2011, 2012 and 2013. Hmmm, let's keep drilling down.


#### By year

{% highlight R %}

ggplot(tw, aes(year(timestamp))) +
geom_histogram(aes(fill = ..count..), breaks = seq(2010.5, 2016, by = 1)) +
xlab("Time") + ylab("Number of Tweets")

{% endhighlight %}

![freq-tweets-by-year](/figs/2016-05-22-exploratory-analysis-shitty-tweets/2-freq-tweets-by-year.png)

Whoa, the difference in the amount of tweets is quite big. What about the frequency by month?

#### By month

{% highlight R%}
ggplot(data = tw, aes(x = month(timestamp, label = TRUE))) +
geom_bar(aes(fill = ..count.. )) +
xlab("Month") + ylab("Number of Tweets")
{% endhighlight %}
![freq-tweets-by-month](/figs/2016-05-22-exploratory-analysis-shitty-tweets/3-freq-tweets-by-month.png)

Ok, this one definitely looks weird, there is a clear difference between the number of tweets in March and April and the other months. I guess It makes sense for 2015 because April was the month of my thesis defense, so I shouldn't have had much time to tweet; however, this is definitely worth looking more in depth.

#### By day

{% highlight R%}

ggplot(data = tw, aes(x = wday(timestamp, label = TRUE))) +
geom_bar(aes(fill = ..count.. )) +
xlab("Day of Week") + ylab("Number of Tweets")

{% endhighlight %}

![freq-tweets-by-day](/figs/2016-05-22-exploratory-analysis-shitty-tweets/4-freq-tweets-by-day.png)

### By hour

{% highlight R%}

tw$timeonly <- as.numeric(tw$timestamp - trunc(tw$timestamp, "days"))
class(tw$timeonly) <- "POSIXct"
ggplot(data = tw, aes(timeonly)) +
geom_histogram(aes(fill = ..count..)) +
theme(legend.position = "none") +
xlab("Time") + ylab("Number of tweets") +
scale_x_datetime(breaks = date_breaks("2 hours"), labels = date_format("%H:00"))

{% endhighlight %}

![freq-tweets-by-hour](/figs/2016-05-22-exploratory-analysis-shitty-tweets/5-freq-tweets-by-hour.png)

It seems like I was a pretty heavy Twitter user. This graph also shows what my sleeping habits used to look like (I had somewhere around 4 hours of sleep each night).

#### Tweets v Mentions v Retweets v Replies v Talking to Myself

What does the type of my tweets look like over time?

{% highlight R %}
ggplot(tw, aes(timestamp, fill = type)) +
geom_histogram(bins = 60) +
xlab("Time") + ylab("Number of Tweets") +
scale_fill_brewer(palette = "Blues", direction = -1)
{% endhighlight %}

![tweets-by-type](/figs/2016-05-22-exploratory-analysis-shitty-tweets/6-tweets-by-type.png)

<small>_(I know, not the best colors for a figure but I did try)_</small>

Well, it seems that in general I didn't talk to myself as much as I thought I did. However, there is an increase of "self replies" in 2015. I also thought that the amount of mentions was bigger, yet it doesn't seem so from looking at this graph.

Ok, lets see what how the proportion looks like:

{% highlight R %}

ggplot(tw, aes(timestamp, fill = type)) +
geom_histogram(position = "fill", bins = 60) +
xlab("Time") + ylab("% of Tweets") +
scale_fill_brewer(palette = "Blues", direction = -1)

{% endhighlight %}

![tweets-by-type-rel](/figs/2016-05-22-exploratory-analysis-shitty-tweets/7-tweets-by-type-rel.png)

It seems there are months in which I only did mentions. Also, the months with not a single tweet are much more evident now. I already covered the months with no tweets on 2015, let's see what the absences before early 2013 are all about.

{% highlight R %}
tw_early <- filter(tw, timestamp <= ymd("2013 03 01", tz = "America/Bogota"))

ggplot(tw_early, aes(timestamp, fill = type))  +
geom_histogram(position = "fill", bins = 22) +
xlab("Time") + ylab("% of Tweets") +
scale_fill_brewer(palette = "Blues", direction = -1)
{% endhighlight %}

![tweets-by-type-rel-pre2013](/figs/2016-05-22-exploratory-analysis-shitty-tweets/8-tweets-by-type-rel-pre2013.png)

So, my early twitter career doesn't seem very impressive. There are a couple of mentions on April 2011 and then no tweets up to August. I was also absent on June 2012 and February 2013. However, I don't remember missing all those months. Unless...

#### The Tragic Tweet Fire

At some point I started to experiment with Twitter's API, but poor exception handling and ignoring of rate limits resulted in me deleting a lot of old tweets. This event plus the fact that I didn't use to tweet a lot before, would explain the weird pattern in March - April and the lack of tweets on the early years. So, when was this TTF? The earliest mention I could find among my existing tweets dates back to _August 2014_ but looking at the sources of my tweets, I found that I started experimenting with the API _before March 2012_. This makes reasonable to think that the TTF happened anytime in between. Ok, moving on.

#### How many characters?

What does the distribution of character counts in my tweets look like?

{% highlight R %}
tw$charsintweet <- sapply(tw$text, nchar)
ggplot(data = filter(tw, type == "tweet"), aes(x = charsintweet)) +
geom_histogram(aes(fill = ..count..), binwidth = 8) +
xlab("Characters per Tweet") + ylab("Number of tweets")
{% endhighlight %}

![chars-per-tweet](/figs/2016-05-22-exploratory-analysis-shitty-tweets/9-chars-per-tweet.png)

Woah, nice! I seem to be more likely to use few characters or go all the way in with 140. There are some weird tweets with more than 140 characters but it turns out that the extra ones are from special characters (`\n`, `&gt` and the like). Also, I don't remember using so little characters (less than ten):

<blockquote class="twitter-tweet" data-lang="en"><p lang="in" dir="ltr">Caramba.</p>&mdash; El gato. (@elgatoninja) <a href="https://twitter.com/elgatoninja/status/672253597904687104">December 3, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="und" dir="ltr">¿Qué?</p>&mdash; El gato. (@elgatoninja) <a href="https://twitter.com/elgatoninja/status/507904426183778304">September 5, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="und" dir="ltr">:(</p>&mdash; El gato. (@elgatoninja) <a href="https://twitter.com/elgatoninja/status/440411907691130880">March 3, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Oh.

## Fine, But What the Hell do All These Tweets Say?

{% highlight R %}
library(tm)
tweets <- stri_trans_general(tw$text, "Latin-ASCII")
tweets <- Corpus(VectorSource(tweets))
tweets <- tm_map(tweets, removePunctuation)
tweets <- tm_map(tweets, tolower)
tweets <- tm_map(tweets, removeWords, stopwords("spanish"))
tweets <- tm_map(tweets, removeWords, stopwords("english"))
tweets <- tm_map(tweets, removeWords, "rt")
tweets <- tm_map(tweets, removeNumbers)
tweets <- tm_map(tweets, stripWhitespace)
tweets <- tm_map(tweets, trimws)
tweets <- tm_map(tweets, PlainTextDocument)

tdm <- TermDocumentMatrix(tweets)
dtm <- DocumentTermMatrix(tweets)

freq <- colSums(as.matrix(dtm))
wf <- data.frame(word=names(freq), freq=freq)

ggplot(subset(wf, freq > 100 & stri_length(word) > 3), aes(word, freq)) +
geom_bar(stat="identity") +
theme(axis.text.x=element_text(angle=45, hjust=1))
{% endhighlight %}

![words_no_stemming](/images/posts/words_no_stemming.png)

![words_no_stemming_freq_100_length_4](/images/posts/words_no_stemming_freq_100_length_4.png)

![words_no_stemming_freq_50_length_5](/images/posts/words_no_stemming_freq_50_length_5.png)

![words_cloud](/images/posts/word_cloud.png)
