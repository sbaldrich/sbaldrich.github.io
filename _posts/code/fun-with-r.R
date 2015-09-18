### Generating the log files
set.seed(20)

library(lubridate)

# now <- now()
now <- ymd_hms("2015-09-20 21:30:00")
logfiles <- c("logfile1.log", "logfile2.log")
for(output.file in logfiles){
  if(file.exists(output.file))
    file.remove(output.file)
  time.span = format(seq(now - minutes(10), now, by = "1 sec"), "%H:%M:%S")
  for(sec in time.span){
    cat(paste(sec, 'Operation # 3 took', rnorm(1,0.5,0.1), 'ms'), "\n", file = output.file, append = TRUE) # Make sure there is at least one operation # 3
    replicate(sample(1:15,1), cat(paste(sec, "Operation #", sample(1:3,1), 'took', rnorm(1,0.5,0.1), 'ms'), "\n", file = output.file, append = TRUE))
  }
}
###

### Parsing and getting relevant info
library(stringr)
library(data.table)

time.pattern <- "(.*) Operation # 3 took (.*) ms"
data <- NULL
for(input.file in logfiles){
  con <- file(input.file)
  lines <- readLines(con)
  close(con)
  tmp.dt <- data.table(str_match(lines, time.pattern))
  setnames(tmp.dt, c("V1", "V2", "V3"), c("line", "date", "runtime"))
  data <- rbind(data, tmp.dt[!is.na(line),])
}
summary(data)
# data$date = hms(data$date) Don't do it. data.table is very picky with dates
data$runtime = as.numeric(data$runtime)
summary <- data[order(date), list(avg.time = mean(runtime), max.time = max(runtime), n.ops = .N), by = date]

###

### Plotting
xPoints <- seq_along(time.span)
plot(avg.time ~ xPoints, xlim = c(0,max(xPoints)), data = summary, type='l', ann = FALSE, col = '#FF000060', axes = FALSE)
axis(2, ylim = range(summary$avg.time), col = 'red', las = 1)
mtext(side = 2, line = 2.6, "Average Runtime")
mtext(side = 1, line = 3.5, "Time")
box()
## Let a second plot appear
par(new = TRUE)

#points(max.time ~ xPoints, data = summary, xlab = '', ylab = '', col = '#0000FF60')
plot(n.ops ~ xPoints, data = summary, type = 'l', ann = FALSE, col = '#0000FF60', axes = FALSE)
axis(4, at = pretty(range(summary$n.ops)), col = 'blue', las = 1)
mtext(side = 4, line = 2.5, "Number of Operations")

xLabels = seq(0, max(xPoints), 60)
axis(1, at = xLabels, labels = FALSE)
text(xLabels, time.span[xLabels], srt = 45, pos = 1, y = 0, xpd = TRUE)

###