#going to use timeSeries package here even though others might be better

library("timeSeries")
lagWtrends <- WTrends[c(62,63)]
lagWtrendsTS <- timeSeries(lagWtrends, by = "Date")
lag7WtrendsTS <- lag(lagWtrendsTS, 7)
lag7WtrendsDF <- as.data.frame(lag7WtrendsTS)
WTrends$weatherL7 <- lag7WtrendsDF$Weather.7.


