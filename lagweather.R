lagWtrends <- WTrends[c(67,68)]
lagWtrendsTS <- timeSeries(lagWtrends, by = "Date")
lag7WtrendsTS <- lag(lagWtrendsTS, 7)
lag7WtrendsDF <- as.data.frame(lag7WtrendsTS)
WTrends$weatherL7 <- lag7WtrendsDF$Weather.7.

