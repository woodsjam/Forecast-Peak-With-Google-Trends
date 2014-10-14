#following libraries are needed

library("reshape2")
library("plyr")

#load in the trends data
load("WTrends.RData")

#temp data frame for reshaping
reshapeWTrends <- WTrends

#dropping unnecessary variables
reshapeWTrends$DATE <- reshapeWTrends$ForecastDate <- reshapeWTrends$Forecasted <- NULL

#need to now rename stuff to make casting easier later
reshapeWTrends <- rename(reshapeWTrends, replace=c("F01" = "F_01"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F02" = "F_02"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F03" = "F_03"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F04" = "F_04"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F05" = "F_05"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F06" = "F_06"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F07" = "F_07"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F08" = "F_08"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F09" = "F_09"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F10" = "F_10"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F11" = "F_11"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F12" = "F_12"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F13" = "F_13"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F14" = "F_14"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F15" = "F_15"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F16" = "F_16"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F17" = "F_17"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F18" = "F_18"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F19" = "F_19"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F20" = "F_20"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F21" = "F_21"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F22" = "F_22"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F23" = "F_23"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("F24" = "F_24"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE01" = "HE_01"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE02" = "HE_02"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE03" = "HE_03"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE04" = "HE_04"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE05" = "HE_05"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE06" = "HE_06"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE07" = "HE_07"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE08" = "HE_08"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE09" = "HE_09"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE10" = "HE_10"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE11" = "HE_11"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE12" = "HE_12"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE13" = "HE_13"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE14" = "HE_14"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE15" = "HE_15"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE16" = "HE_16"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE17" = "HE_17"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE18" = "HE_18"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE19" = "HE_19"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE20" = "HE_20"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE21" = "HE_21"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE22" = "HE_22"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE23" = "HE_23"))
reshapeWTrends <- rename(reshapeWTrends, replace=c("HE24" = "HE_24"))



#time to melt, we are melting all the F_xx and HE_xx
meltedreshapeWTrends <- melt(reshapeWTrends, id = c("Date","COMP", "DETrends", "GasTrends", "KYTrends", "MDTrends", "MovieTrends", "NewsTrends", "NJTrends", "OHTrends", "PATrends", "RestaurantTrends", "TrafficTrends","VATrends", "WVTrends", "TrendDate", "Weather", "weatherL7"))

#now we need to spereate out the hour from the F or HE, usling colsplit here
meltedreshapeWTrends <- cbind(meltedreshapeWTrends, colsplit(meltedreshapeWTrends$variable, "_", c("ForHE", "hour")))

#time to cast, we are going to cast using all the ID plus using hour as a column, F and HE end up as their own columns
castedreshapeWTrends <- dcast(meltedreshapeWTrends, Date + hour + DETrends + GasTrends + KYTrends + MDTrends + MovieTrends + NewsTrends + NJTrends + OHTrends + PATrends + RestaurantTrends + TrafficTrends + VATrends + WVTrends + TrendDate ~ ForHE + Weather + weatherL7)

#make new dataframe of results
LongWtrends <- castedreshapeWTrends

#save the new data frame
save(LongWtrends, file="LongWtrends.Rdata")
