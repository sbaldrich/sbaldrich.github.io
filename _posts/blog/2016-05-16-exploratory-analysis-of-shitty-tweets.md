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

{% highlight R %}
library(dplyr)
library(ggplot2)
library(lubridate)
tw <- read.csv("tweets.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
{% endhighlight %}

{% highlight R %}
own.id <- 271769778 # yup, that's me.
tw <- mutate(tw, timestamp = ymd_hms(timestamp),
            is_reply = (!is.na(in_reply_to_user_id) &
                        in_reply_to_user_id != own.id),
            own_reply = (in_reply_to_user_id == own.id))
{% endhighlight %}


### All tweets

{% highlight R %}
ggplot(tw, aes(timestamp)) + geom_histogram(aes(fill = ..count..), bins = 60) +
    xlab("Time") + ylab("Number of Tweets") +
    theme(text = element_text(size = 16))
{% endhighlight %}

![all_time_tweets](/images/posts/tweets_all_time.png)


### By year

{% highlight R %}
ggplot(tw, aes(year(timestamp))) + geom_histogram(aes(fill = ..count..),
  breaks = seq(2010.5, 2016, by = 1)) + xlab("Time") +
  ylab("Number of Tweets") + theme(text = element_text(size = 16))
{% endhighlight %}

![tweets_by_year](/images/posts/tweets_by_year.png)

### By month

{% highlight R%}
ggplot(data = tw, aes(x = month(timestamp, label = TRUE))) +
    geom_bar(aes(fill = ..count.. )) + xlab("Month") +
    ylab("Number of Tweets") + theme(text = element_text(size = 16))
{% endhighlight %}
![tweets_by_month](/images/posts/tweets_by_month.png)


### By day

{% highlight R%}
ggplot(data = tw, aes(x = wday(timestamp, label = TRUE))) +
    geom_bar(aes(fill = ..count.. )) + xlab("Day of Week") +
    ylab("Number of Tweets") + theme(text = element_text(size = 16))
{% endhighlight %}

![tweets_by_day](/images/posts/tweets_by_day.png)

### By hour

{% highlight R%}
tw$timeonly <- as.numeric(tw$timestamp - trunc(tw$timestamp, "days"))
class(tw$timeonly) <- "POSIXct"
ggplot(data = tw, aes(timeonly)) +
        geom_histogram(aes(fill = ..count..)) +
        theme(legend.position = "none") +
        xlab("Time") + ylab("Number of tweets") +
        scale_x_datetime(breaks = date_breaks("3 hours"),
                         labels = date_format("%H:00")) +
        theme(text = element_text(size = 16))
{% endhighlight %}

![tweets_by_hour](/images/posts/tweets_by_hour.png)


## Text Processing

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
