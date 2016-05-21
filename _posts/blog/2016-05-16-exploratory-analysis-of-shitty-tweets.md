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

{% highlight R %}
library(dplyr)
library(ggplot2)
library(lubridate)
tw <- read.csv("tweets.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
{% endhighlight %}  

### Preprocessing

I used to talk to myself a lot (both in Twitter and real life), so I chose to separate tweets tweets between "real" tweets, replies, and replies to myself. To do this, I got my Twitter id and simply checked whether the user I'm replying to is me or not.

{% highlight R %}
own.id <- 271769778 # yup, that's me.
tw <- mutate(tw, timestamp = ymd_hms(timestamp),
      is_reply = (!is.na(in_reply_to_user_id) & in_reply_to_user_id != own.id),
      own_reply = (in_reply_to_user_id == own.id))
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

It seems I started tweeting a lot in the end of 2014 and had a couple of months of in 2015. This seems reasonable since I started working during the night on my thesis document and Twitter was a good way of keeping me awake. Let's keep drilling down.

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

<small>Thanks to [Julia Silge](http://juliasilge.com/blog/Ten-Thousand-Tweets/) (who coincidently also uses the [So-Simple](https://mmistakes.github.io/so-simple-theme/) theme for her blog) for this graph.</small>

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

## Ok, So What the Hell do All These Tweets Say?

#### Tweets v Retweets v Replies v Talking to Myself

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
